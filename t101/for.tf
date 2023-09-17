resource "local_file" "abc" {
  count    = 5
  content  = "abc${count.index}"
  filename = "${path.module}/abc.txt"
}

output "filecontent" {
  value = local_file.abc.*.content
}

output "fileid" {
  value = local_file.abc.*.id
}

output "filename" {
  value = local_file.abc.*.filename
}
