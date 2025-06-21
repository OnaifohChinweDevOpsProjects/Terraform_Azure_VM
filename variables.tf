# variable "prefix" {
#   type    = string
#   default = "my"
# }

# variable "prefix_map" {
#   type = map 
#   default = {
#     "prefix1" = "my"
#     "prefix2" = "our"
#     "prefix3" = "your"
#     "prefix4" = "their"
#     "prefix5" = "his"
#   }
# }

# variable "prefix_number" {
#   type    = number
#   default = 6
# }

# variable "prefix_list" {
#   type    = list
#   default = ["my", "our", "your", "their", "his"]
# }

# variable "prefix_tuple" {
#   type    = tuple([string, string, string])
#   default = ["my", "our", "your"]

# }

# 
variable "user_principal_name" {
  type        = string
  default     = "ebube094_outlook.com#EXT#@ebube094outlook.onmicrosoft.com"
  description = "value for user principal name"
}