locals {
  blacklisted_countries = {
    "AR" = "Argentina"
    "BD" = "Bangladesh"
    "BR" = "Brazil"
    "CN" = "China"
    "CO" = "Colombia"
    "EC" = "Ecuador"
    "ID" = "Indonesia"
    "IN" = "India"
    "IR" = "Iran"
    "MX" = "Mexico"
    "PH" = "Philippines"
    "RU" = "Russian Federation"
    "TH" = "Thailand"
    "TR" = "Turkey"
    "VN" = "Vietnam"
  }
  blacklisted_ipv4_addresses = [
    "166.109.239.42/32", # DDoS
    "117.187.18.136/32", # DDoS
    "51.79.229.202/32",  # DDoS
    "139.162.52.57/32"   # DDoS
  ]
  blacklisted_ipv6_addresses = [
    "2606:54c0:7680:d28::1d3:53/128" # Sample IP Address
  ]
  blacklisted_user_agents = [
    "nintento",
    "playstation",
    "xbox"
  ]
  whitelisted_ipv4_addresses = [
    "127.0.0.1/32"
  ]
  whitelisted_ipv6_addresses = [
    "::1/128"
  ]
  aws_rate_limit  = 500     # requests allowed in 5 minute span per IP
  aws_access_mode = "count" # action to take on aws side for blacklisted_countries, can be "count" or "block"
}
