# de.hs-fulda.informatik.biig

# Description:

Our web application BiiG alleviates customers and listing agents to find/rent most suitable properties.It will be exclusively used by real estate agents from the following three local real estate companies SFStateHome, SJStateRealtors and CSURealEstate. They can post content and receive contacts/request from customers/buyers. The title BiiG expresses the following component. Each team member comes from another country. “B” stand for Bangladesh , “i” for india, “i” for Iran and “G” for Germany. Diversity and the courage to think big are important features in our team that we also want to reflect with BiiG.

In addition to our unique features,our website is based on the functional range of known real estates sites: For example this includes the search for specific properties by price,size or number of rooms.Afterwards,the interested consumer/buyer can contact directly the corresponding listing agents for the property.BiiG is based on the most up to date technologies and thus offers,with regard to performance at the state of the art.

# Teamwork:
Application Url: https://evening-waters-97508.herokuapp.com/

I worked mainly in Backend development and few in Frontend development those include as follows:
1. Database design and normalization
2. Create store procedure for creating customer
3. Write some util sql queries to load data in frontend such as in drop-down menu, checkboxes etc.
4. Create dynamic search, sort sql query for searching and sorting properties as per user input or filter criterias.
5. Create MVC structure of property search at the beginning of the project so that other members can follow the dataflow of MVC for further development.
6. Worked on the following features:
        property search, 
        add favorite properties, 
        agent dashboard including sql quries, UI design.

# Individual Part:
Swift 4, Xcode 9.2, Google Maps API, Google Direction Web Service, BiiG Heroku Cloud API.

# How to run the project in Xcode 9:
1. This project has 3 dependencies. All are exist within biig-ios-mahbub/Pods directory.

2. If anyone wants to update these, please remove NavigateMe/Pods directory and Podfile.lock

3. Then please enter inside the directory biig-ios-mahbub/ using "cd" where Podfile exists.

        cd biig-ios-mahbub/

4. After that, please run command "pod install"

        If CocoaPods is not install in machine then please install it using "sudo gem install cocoapods" command.

5. The above command will install all dependencies mentioned in the Podfile.

6. After successful dependecies installation, please run BIIG.xcworkspace instead of BIIG.xcodeproj

7. Finally, please check followings:

        please click "Project Navigator" tab in left pannel, then
                BIIG(Top in 1st Tree) Targets -> BIIG -> Build Settings -> Enable Bitcode -> Yes

   If "Enable Bitcode" is set to "No", then please change the value to "Yes".

