function(doc) {
  if(doc['couchrest-type'] == "Message")
  {
    emit(1, [doc['receiver'],doc['content']]);
  }
}