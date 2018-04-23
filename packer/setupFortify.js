var testindex = 0;
var loadInProgress = false;//This is set to true when a page is still loading

/*********SETTINGS*********************/
var webPage = require('webpage');
var system = require('system');
var env = system.env;
var fs = require('fs')
var init_token = fs.read('/home/ec2-user/init.token')
var page = webPage.create();
var isSeeding=false;
page.settings.userAgent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36';
page.settings.javascriptEnabled = true;
page.settings.loadImages = false;//Script is much faster with this field set to false
phantom.cookiesEnabled = true;
phantom.javascriptEnabled = true;
/*********SETTINGS END*****************/

console.log('All settings loaded, start with execution');
page.onConsoleMessage = function(msg) {
    console.log(msg);
};

steps = [

	//Step 1 - Open Amazon home page
    function(){
        console.log('Step 1 - Open Fortify Page');
        page.open("http://localhost:8080/ssc/init.jsp", function(status){
		});
      page.render('1.png');
    },

	//Step 2 - Populate and submit the login form
    function(){
        console.log('Step 2 - Populate and submit the page with the init token');
        console.log('init_token=' + init_token)
	      page.evaluate(function(token){
			       document.getElementById("password").value=token;
             document.querySelector("#submit").click();
		    }, init_token);
        page.render('2.png');
    },
	//Step 3 - Wait for Fortify to login user, then click 'Next' in the wizard
    function(){
		    console.log("Step 3 - Wait for fortify to log you in, then click the 'Next' button in the wizard");
		    page.evaluate(function() {
			       document.querySelector("#btnNextAppWizard").click();
  	    });
        page.render('3.png');
    },


    //Step 4 - Click the 'I have read and understood this warning' checkbox, then click The Next button
    function() {
      console.log("Step 4 - Click the 'I have read and understood this warning' checkbox")
      page.evaluate(function() {
        document.querySelector("#acceptConfigWarning").click();
      });
      page.render('4.png');
    },

    function() {
      console.log("Step 4a - Click Next")
      page.evaluate(function() {
          document.querySelector("#btnNextAppWizard").click();
      });
      page.render('4a.png');
    },

    //Step 5 - Click the 'Next Button again' to accept the Fortify Center URL
    function() {
      console.log("Step 5 - Click the 'Next Button again' to accept the Fortify Center URL")
      page.evaluate(function() {
        document.querySelector("#btnNextAppWizard").click();
      });
      page.render('5.png');
    },

    //Step 6a - Input the database username
    function() {
      console.log("Step 6a - Input the database username")
      sendKeys(page, "#databaseUsername", "blah");
      page.render('6a.png');
    },


    // Step 6b - Input the database password
    function() {
      console.log("Step 6b - Input the database password")
      sendKeys(page, "#databasePassword", "blahblahblah");
      page.render('6b.png')
    },

    // Step 6c - Test the database connection
    function() {
      console.log("Step 6c - Test the database connection")
      page.evaluate(function() {
        document.querySelector("#testConnection").click();
      });
      page.render('6c.png');
    },

    // Step 6d - Click Next
    function() {
      console.log("Step 6d - Click Next")
      page.evaluate(function() {
        document.querySelector("#btnNextAppWizard").click();
      })
      page.render('6d.png')
    },

    function() {
      console.log("Step 7 - Load the First Seed Bundle")
      page.uploadFile('#input-file', '/home/ec2-user/HP_Fortify_Process_Seed_Bundle-2017_Q3.zip');
      page.render('7.png');
    },

    function() {
      console.log("Step 8 - Click 'Seed Database'")
      page.evaluate(function() {
        document.querySelector("#seedDatabase").click();
      });
      page.render('8.png')
    },


    function(){
      console.log("Step 9 - Wait until Seeding is done...")
      isSeeding = page.evaluate(function waitSeedingEnd() {
        var scope = angular.element($("#wait")).scope();
        isSeeding = scope.dbSeedingVM.isSeeding
        if(isSeeding===true) {
          console.log("try again. seeding: " + isSeeding)
          return true
        } else {
          return false
        }
      });
      page.render('9.png')
    },

    function() {
      console.log("Step 10 - Load the Second Seed Bundle")
      page.uploadFile('#input-file', '/home/ec2-user/HP_Fortify_Report_Seed_Bundle-2017_Q3.zip');
      page.render('10.png');
    },

    function() {
      console.log("Step 11 - Click 'Seed Database'")
      page.evaluate(function() {
        document.querySelector("#seedDatabase").click();
      });
      page.render('11.png')
    },


    function(){
      console.log("Step 12 - Wait until Seeding is done...")
      isSeeding = page.evaluate(function waitSeedingEnd() {
        var scope = angular.element($("#wait")).scope();
        isSeeding = scope.dbSeedingVM.isSeeding
        if(isSeeding===true) {
          console.log("try again. seeding: " + isSeeding)
          return true
        } else {
          return false
        }
        console.log("Seeding: " + isSeeding)
      });
      page.render('12.png')
    },

    // Step 13 - Click Next
    function() {
      console.log("Step 13 - Click Next")
      page.evaluate(function() {
        document.querySelector("#btnNextAppWizard").click();
      })
      page.render('13.png')
    },


    // Step 14 - Click Finish
    function() {
      console.log("Step 14 - Click Finish")
      page.evaluate(function() {
        document.querySelector("#btnNextAppWizard").click();
      })
      page.render('14.png')
    },


    // Last step - as a debug, wait for the page and print entire thing to a document to see if I did it right
    function(){
		console.log("Last Step - Wait for next page, and render a pic called F.png");

		  page.evaluate(function() {
			     document.querySelectorAll("html")[0].outerHTML;
		  });
      page.render('F.png')

    },
];
/**********END STEPS THAT FANTOM SHOULD DO***********************/

//Execute steps one by one
interval = setInterval(executeRequestsStepByStep,5000);



function executeRequestsStepByStep(){
  console.log("executeRequests: isSeeding=" + isSeeding)
    if (loadInProgress == false && typeof steps[testindex] == "function" && isSeeding == false) {
        //console.log("step " + (testindex + 1));
        steps[testindex]();
        testindex++;

    } else if (loadInProgress == false && typeof steps[testindex] == "function" && isSeeding == true) {
      console.log("pause...")
      // had already proceeded to the next step, so re-execute the step before of checking if
      // isSeeding is true/false
      steps[testindex - 1]();
    }

    if (typeof steps[testindex] != "function") {
        console.log("test complete!");
        phantom.exit();
    }
}

/**
 * These listeners are very important in order to phantom work properly. Using these listeners, we control loadInProgress marker which controls, weather a page is fully loaded.
 * Without this, we will get content of the page, even a page is not fully loaded.
 */
page.onLoadStarted = function() {
    loadInProgress = true;
    console.log('Loading started');
};
page.onLoadFinished = function() {
    loadInProgress = false;
    console.log('Loading finished');
};
page.onConsoleMessage = function(msg) {
    console.log(msg);
};


function sendKeys(page, selector, keys){
    page.evaluate(function(selector){
        // focus on the text element before typing
        var element = document.querySelector(selector);
        element.click();
        element.focus();
    }, selector);
    page.sendEvent("keypress", keys);
}



phantom.onError = function(msg, trace) {
  var msgStack = ['PHANTOM ERROR: ' + msg];
  if (trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function(t) {
      msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function +')' : ''));
    });
  }
  console.log(msgStack.join('\n'));
  phantom.exit(1);
};
