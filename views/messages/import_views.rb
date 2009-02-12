
@db.save(
{
  "_id" => "_design/messages",
  :views => {
    :by_totals => {
      :map => "function(doc) {
        if(doc['couchrest-type'] == \"Message\")
        {
          emit(1, [doc['receiver'],doc['action']]);
        }
      }",
      :reduce => "function(key, values, rereduce)
      {
        var final_result = [];

        for(j = 0; j < values.length; j++)
        {
          var result_key = values[j][0];
          var props = 0;
          var drops = 0;


          if(values[j][1] == 'prop')
          {
            props++;
          }
          else
          {
            drops++;
          }

         final_result.push({'key' : result_key, 'props' : props, 'drops' : drops, 'totals' : props - drops})
        }


        sorted_result = final_result.sort(function(a,b){return b.totals - a.totals;})

        var limited_sorted_result = []
        for(i = 0; i < 10 && i < sorted_result.length ; i++)
        {
          limited_sorted_result.push(sorted_result[i]);
        }

      return limited_sorted_result;
      }"
    },
    
    :by_receiver_totals=> {
      :map => "function(doc) {
        if(doc['couchrest-type'] == \"Message\")
        {
          emit(doc['receiver'],doc['action']);
        }
      }",
      :reduce => "function(key, values, rereduce)
      {
        var props = 0;
        var drops = 0;
    
        for(var i = 0; i < values.length; i++)
        {
          if(values[i] == 'prop')
          {
            props++;
          }
          else
          {
            drops++;
          }
        }
    
        return {'props' : props, 'drops' : drops, 'totals' : props - drops};
      }"},
      
    :by_props => {
      :map => "function(doc) {
        if(doc['couchrest-type'] == \"Message\")
        {
          emit(1, [doc['receiver'],doc['content']]);
        }
      }",
      :reduce => "function(key, values, rereduce)
      {
        var final_result = [];

        for(j = 0; j < values.length; j++)
        {
          var result_key = values[j][0];
          var props = 0;
          var drops = 0;


          if(values[j][1] == 'prop')
          {
            props++;
          }
          {
            drops++;
          }

         final_result.push({'key' : result_key, 'props' : props, 'drops' : drops, 'totals' : props - drops})
        }


        sorted_result = final_result.sort(function(a,b){return b.props - a.props;})

        var limited_sorted_result = []
        for(i = 0; i < 10 && i < sorted_result.length ; i++)
        {
          limited_sorted_result.push(sorted_result[i]);
        }

      return limited_sorted_result;
      }"
      },
      
      :by_drops => {
        :map => "function(doc) {
          if(doc['couchrest-type'] == \"Message\")
          {
            emit(1, [doc['receiver'],doc['content']]);
          }
        }",
        :reduce => "function(key, values, rereduce)
        {
          var final_result = [];

          for(j = 0; j < values.length; j++)
          {
            var result_key = values[j][0];
            var props = 0;
            var drops = 0;


            if(values[j][1] == 'prop')
            {
              props++;
            }
            {
              drops++;
            }

           final_result.push({'key' : result_key, 'props' : props, 'drops' : drops, 'totals' : props - drops})
          }


          sorted_result = final_result.sort(function(a,b){return b.props - a.props;})

          var limited_sorted_result = []
          for(i = 0; i < 10 && i < sorted_result.length ; i++)
          {
            limited_sorted_result.push(sorted_result[i]);
          }

        return limited_sorted_result;
        }"
        },
        
    :by_handle => {
      :map => "function(doc) {
        if(doc['couchrest-type'] == \"Message\")
        {
          emit(doc['receiver'], doc);
          emit(doc['author']['handle'], doc);
        }
      }"
      },
      
    
      :by_receiver => {
        :map => "function(doc) {
          if(doc['couchrest-type'] == \"Message\")
          {
            emit(doc['receiver'], doc);
          }
        }"
        }
        
        
    }
  
})
