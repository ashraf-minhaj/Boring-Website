let activity;
var api_url     = 'https://www.boredapi.com/api/activity';
var api_method  = 'GET'; 

function get_data() {
    console.log("Starting");

    fetch(api_url, 
        {
            method:api_method
        }).then(response=>{
            activity = response.text
            return response.json()
        }).then(data=> 
            // this is the data we get after putting our data,
            // console.log(data)
            activity = data
            );

        document.getElementById("text").textContent = activity?.activity;
};