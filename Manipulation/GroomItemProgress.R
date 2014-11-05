rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. 
# library(lubridate)
library(dplyr)
# library(reshape2)

possible_sessions <- 1:30
possible_clients <- 1:2

pad_session_number <- function( event ) {
  gsub("(c\\d_session_)(\\d)(_arm_\\d)", "\\10\\2\\3", event)
}
strip_arm_from_event <- function( event ) {
  gsub("(c\\d_)(session_\\d{2})(_arm_\\d)", "\\2", event)
}

dsSessionSurvey <- read.csv("./DataPhiFree/Raw/SessionSurvey.csv", stringsAsFactors=FALSE)
ds_item_label <- read.csv("./DataPhiFree/Raw/ItemLabel.csv", stringsAsFactors=FALSE) 

# GroomItemProgress <- function( pathSessionSurvey = "./DataPhiFree/Raw/SessionSurvey.csv") {
  #' LoadData
#   if( !file.exists(pathSessionSurvey) ) stop("The file `", normalizePath(pathSessionSurvey, mustWork=FALSE), "` does not exist.")
#   dsSessionSurvey <- read.csv(pathSessionSurvey, stringsAsFactors=FALSE)
  
#####################################
#' Tweak Session Data

dsSessionSurvey$email <- tolower(dsSessionSurvey$email)

# Extract client sequence
client1 <- grepl(pattern="^session",  dsSessionSurvey$redcap_event_name)
client2 <- grepl(pattern="^c2_session",  dsSessionSurvey$redcap_event_name)
dsSessionSurvey$client_sequence <- NA_integer_
dsSessionSurvey$client_sequence[client1] <- 1L
dsSessionSurvey$client_sequence[client2] <- 2L

dsSessionSurvey$redcap_event_name <- ifelse(client1, paste0("c1_", dsSessionSurvey$redcap_event_name), dsSessionSurvey$redcap_event_name)
dsSessionSurvey$redcap_event_name <- pad_session_number(dsSessionSurvey$redcap_event_name)
rm(client1, client2)

columns_plumbing <- c("therapist_id_rc", "client_sequence", "redcap_event_name") #, "email"

branches <- c("psycho_education", "parenting_skills", "relaxation", "assist", "cognitive_coping", "trauma_narrative", "invivo_desensitization", 
              "child_parent", "address_safety", "tfcbt_completed")

branch_psycho_education <- c("psycho_education", "psycho_education_general", "psycho_education_common_responses", 
                             "psycho_education_symptoms", "psycho_education_components", "psycho_education_engaged_family")
branch_parenting_skills <- c("parenting_skills")
branch_relaxation <- c("relaxation", "relaxation_trauma_help")
branch_assist <- c("assist", "assist_express_feelings", "assist_link_feelings", "assist_rate_emotions", 
                   "assist_manage_emotions", "assist_cope_feelings")
branch_cognitive_coping <- c("cognitive_coping", "cognitive_coping_educate", "cognitive_coping_alternative")
branch_trauma_narrative <- c("trauma_narrative", "trauma_narrative_rationale", "trauma_narrative_details", "trauma_narrative_reread", 
                             "trauma_narrative_add_thoughts", "trauma_narrative_worst_memory", "trauma_narrative_cognitive_processing",
                             "trauma_narrative_meaning", "trauma_narrative_read_draft")
branch_invivo_desensitization <- c("invivo_desensitization")
branch_child_parent <- c("child_parent", "child_parent_prepare", "child_parent_joint_session")
branch_address_safety <- c("address_safety", "address_safety_teach_skills", "address_safety_social_skills")

columns_components_list <- list(branch_psycho_education, branch_parenting_skills, branch_relaxation, branch_assist, branch_cognitive_coping, 
                branch_trauma_narrative, branch_invivo_desensitization, branch_child_parent, branch_address_safety)
columns_components <- unlist(columns_components_list)
columns_components_spaces <- gsub("_", " ", columns_components)
# columns_components_capitalized <- gsub("\\b(\\w)", toupper("\\1"), columns_components_spaces)
# columns_components_capitalized
# write.csv(data.frame(item=columns_components, description_short=columns_components_spaces, description_long=NA_character_, variable_index=seq_along(columns_components)), file="./DataPhiFree/Raw/ItemLabel.csv", row.names=FALSE)

ds_eav <- reshape2::melt(dsSessionSurvey, id.vars=columns_plumbing, measure.vars=columns_components,
                          variable.name="item", value.name="score", factorsAsStrings=FALSE)
ds_eav$score <- as.logical(ifelse(is.na(ds_eav$score) | (ds_eav$score==2L), 0L, ds_eav$score))
ds_eav$score <- ifelse(ds_eav$score, "YES&ensp;", "&ensp;n&ensp;&ensp;")
ds_eav$item <- factor(ds_eav$item, levels=columns_components)


# ds_eav$session_number <- as.integer(gsub("(c\\d_session_)(\\d{2})(_arm_\\d)", "\\2", ds_eav$redcap_event_name))
ds_eav$session_name <- strip_arm_from_event(ds_eav$redcap_event_name)
# ds_eav$session_name <- gsub("(c\\d_)(session_\\d{2})(_arm_\\d)", "\\2", ds_eav$redcap_event_name)


# On row per client's item (over the sessions)
ds_item_client <- reshape2::dcast(ds_eav, item + therapist_id_rc + client_sequence ~ session_name, value.var="score")
ds_item_client <- ds_item_client[order(ds_item_client$therapist_id_rc, ds_item_client$client_sequence), ]
ds_item_client$branch_item <- as.integer(ds_item_client$item %in% branches)

ds_item_client <- merge(x=ds_item_label, y=ds_item_client, by="item", all=T)
ds_item_client <- ds_item_client[order(ds_item_client$therapist_id_rc, ds_item_client$client_sequence, ds_item_client$variable_index), ]

# c("survey_id", "therapist_id_rc", "redcap_event_name", "session_date", 
# "survey_trigger", "original_client_still_participating", "therapist_identifier", 
# "client_gender_male", "client_age", "client_number", "client_attend", 
# "tfcbt_model_use", "trauma_session", "caregiver_score", "child_score", 
# "tfcbt_model_use_no_1", "tfcbt_model_use_no_2", "caregiver_included", 
# 
# "tfcbt_completed", "tfcbt_checklist_complete", 
# "email", "contact_info_complete", 
# "date_upload_to_sql", "session_ym")

#################################
## Fill in the email addresses
ds_email <- dsSessionSurvey %>%
  group_by(therapist_id_rc) %>%
  dplyr::summarize(
    email = email[1]
    # e = modeest::mlv(email[!is.na(email)], method = "discrete")
  )
testit::assert("All email addresses should be nonmissing.", all(!is.na(ds_email$email)))
# modeest::mlv(dsSessionSurvey$email[!is.na(dsSessionSurvey$email)], method = "discrete")

ds_item_client <- dplyr::left_join(x=ds_item_client, y=ds_email, by="therapist_id_rc")
ds_item_client <- plyr::rename(ds_item_client, replace=c("email"="therapist_email"))
# ds_item_client$therapist_email_short <- 
# gsub("^(.+)ds_item_client$therapist_email

columns_initial <- c("description_short", "client_sequence", "item", "description_long", "variable_index")
columns_ending <- c("therapist_email", "therapist_id_rc", "branch_item")
columns_remaining <- setdiff(colnames(ds_item_client), c(columns_initial, columns_ending))

# table(ds_item_client$email)
ds_item_client <- ds_item_client[, c(columns_initial, columns_remaining, columns_ending)]
dput(colnames(ds_item_client))

#################################
## Save to disk
write.csv(ds_item_client, file="./DataPhiFree/Derived/ItemProgress.csv", row.names=F)

#################################
## Questions
