function(key, values, rereduce)
{
  var props = 0;
  var drops = 0;

  for(var i = 0; i < values.length; i++)
  {
    if(values[i].match(/^@?props?/) != null)
    {
      props++;
    }

    if(values[i].match(/^@?drops?/) != null)
    {
      drops++;
    }
  }

  return {'props' : props, 'drops' : drops, 'totals' : props - drops};
}