### Monster Shop - Turing Back End Engineering, Module 2, Group Project

Heroku App: https://jbrw-monstershop.herokuapp.com/
Schema Design: https://ondras.zarovi.cz/sql/demo/?keyword=default

Collaborators:
Becky Robran: https://github.com/rer7891

Jomah Fangonilo: https://github.com/jfangonilo

Ray Nguyen: https://github.com/itemniner

Wren Steitle: https://github.com/wrenisit

### Overview:
Monster Shop is a fictional ecommerce website that allows you to browse through merchants and their items, add goods to your cart, and check out.

As a user, you have the ability to peruse the website without logging in, and add items to your cart. When you are ready to check out, you are required to register or log in to your profile. Once you have a profile, you have the ability to check out, change your password, change your personal information, view orders, or continue shopping.

As a merchant, you have two different roles, merchant employee or merchant admin. A merchant employee can fulfill orders, create items, delete items, and view orders placed for that merchant. As a merchant admin, you have the same functionality, and you also have the ability to edit the merchant data.

As an administrator, you have admin only views of merchant pages and user pages, except password edit. An admin can also fulfill and ship orders on behalf of a merchant. An admin has the ability to activate and deactivate merchants and users, as well as change the role of a user.

### Cart:
As a visitor you can visit merchant pages and add items to your cart. You can update the item quantity in your cart with a Add Item/Subtract Item button by each item. You cannot checkout an order as a visitor.

As a logged in regular user you can add items to your cart and check out. Once you check out an order is created and any merchant that has items in your order will receive a copy of that order with their items to fulfill. Once an order's items are all fulfilled the status of that order goes from pending to packaged. At this point a user can no longer cancel an order.

Once an order is pending an admin can ship that order and the status of that order is updated shipped.

If a user logs out with items in their cart those items are deleted.

Personal Wins:
Becky: Becoming more comfortable with complex Active Record queries as well as understanding
relationships within a complex schema. I also became more comfortable with form_for and partials.

Jomah: This project has allowed me to build a solid technical foundation in Rails, MVC model, RESTfulness, and OOP principles. It has also been a great experience in working on a group project with tight deadlines. Managing git workflow at a fast pace has been a great challenge and experience.

Ray: This project has been a great learning experience in making an ecom website. Being able to implement features that I've used on amazon and other online shops has been really interesting. Working with great partners and learning all the new tools on rails has been a big win for me!

Wren: Working through this project was a fantastic opportunity to work in two major growth areas: brown field code and branching out from user stories. The original repo was set up for us, and included a bit of code. This was great experience for me on working in someone else's code base. Also, as the user stories progressed, I spent a significant amount of time working in code that another of my team mates had built to further my functionality. I greatly enjoyed the challenge, and feel that it was a fantastic learning opportunity. The other major area of growth was branching off from the user stories. I worked on creating functionality for users to be able to message a merchant through the site, reply to a merchant message, and the same for merchants to users. Due to time constraints, our team did not feel the code was well enough tested to push into production. Attached are a few of the screen shots of the functionality we were building but did not feel was refined enough to include in master.

Our table in the schema: https://user-images.githubusercontent.com/49083187/72099744-279cae00-3319-11ea-90a1-ce7ccba55a87.png

Messages Controller: https://user-images.githubusercontent.com/49083187/72099762-2ec3bc00-3319-11ea-8747-87266e640ccf.png

The dashboard with a link to the messages index page: https://user-images.githubusercontent.com/49083187/72099768-34210680-3319-11ea-836e-e562eed52829.png

Messages index page: https://user-images.githubusercontent.com/49083187/72099781-397e5100-3319-11ea-8185-ead57bb2c555.png

Message show page with reply and delete buttons: https://user-images.githubusercontent.com/49083187/72099803-41d68c00-3319-11ea-917c-0e60be523e1f.png

Future Goals: Were we to continue this project, I would finish the implementation of the messaging service, including admin to user or admin to merchant and reverse. I would also include a show page for messages sent along with their status as read or unread for both merchant and user.
