# Tamagotchi

## Requirements


1. Ruby 

## Download
1. Clone repository 
```
git clone https://github.com/Mira21-prog/RubyHW
```
## Instruction
2. Run in console
```
bundle 
```
3. Run file in console 
```
bundle exec ruby tamagotchi.rb
```
4. Enter login: 
```
Enter login:thebestuser
```
5. Enter password: 
```
Enter login:thebestuser
```
You get message: "Welcome, GUEST!"

---
All info for authorization
| login | password |
| --- | --- |
| thebestuser | thebestuser |
| thebestadmin | thebestadmin |
| thebestsuperadmin | thebestsuperadmin |
---

6. Write name of pet in console(for example: Chewey)

```
Please, write the name of the pet=> Chewey
```
7. Choose a cat or dog (for example:cat). After thet you get image 

```
Do you have a cat or a dog?=> cat
```

8.  Write any command(for example: play, grooming) 

```
=>play
```
- The file will open in the browser automatically. 
- After choosing a new the command, reload the page to see the result.

![cat](http://dl3.joxi.net/drive/2020/11/19/0015/2025/1005545/45/a6785f09ae.jpg)
1. Welcome with pet's name
2. It is message appears after selected option
3. Characteristic  
4. Help button 
5. Pet's image

or 

```
=>grooming
```

or `exit` if need to finish game

```
=>exit
```

or `pet_status` you get the current state of the pet

```
=>pet_status
```
or `pet_needs` what needs to be improved for the pet
```
=>pet_needs
```
|All options in menu for user:| 
|--------------------|
|play|
|eat|
|drink|
|treat|
|dream|
|awake|
|overwatch|
|grooming|
|restroom|
|walking|
|pet_status|
|help|
|pet_needs|
---
|All options in menu for admin:| 
|--------------------|
|play|
|eat|
|drink|
|treat|
|dream|
|awake|
|overwatch|
|grooming|
|restroom|
|walking|
|pet_status|
|help|
|pet_needs|
|change_pet_type|
|change_pet_name|
---
|All options in menu for superadmin:| 
|--------------------|
|play|
|eat|
|drink|
|treat|
|dream|
|awake|
|overwatch|
|grooming|
|restroom|
|walking|
|pet_status|
|help|
|pet_needs|
|change_pet_type|
|change_pet_name|
|kill_pet|
|set_default_score|


9. Pet has 5 lifes. If one of the states is 0 and you did not fix it, then one life is taken away.If there are 0 lives, then you leave the program and you need to start the program again


10. Some parameters will decrease every 10 minutes

Good luck! 



