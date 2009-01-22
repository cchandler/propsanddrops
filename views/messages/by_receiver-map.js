function(doc) {
  if(doc['couchrest-type'] == "Message")
  {
    emit(doc['receiver'], doc);
  }
}