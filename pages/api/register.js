import {  PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

export default async function handler(req, res) {
    let status_code
    let status
    let message
    if(req.method === 'POST'){
        const data = req.body
        const email = data.email
        const password = data.password
        const name = generateName(email)
        const user = await register(name, email, password)
        if(user){
            status_code = 200
            status = true
            message = "Registered account"
        }
        else{
            status_code = 404
            status = false
            message = "This email address is already exist"
        }
    }
    else{
        status_code = 404
        status = false
        message = "Invalid request"
    }
    res.status(status_code).json({ status: status, message: message })
}

// register user
async function register(name, email, password){
    if(await isUserExist(email) == false){
        console.log("Creating User")
        const user = await prisma.user.create({
            data: {
                name: name,
                email: email,
                password: password,
            },
          })
      await prisma.$disconnect()
      return user
    }
}

// check if user already exists
async function isUserExist(email){
    const user = await prisma.user.findFirst({
        where:{
            email: email,
        }
    })
    if(user){
        return true
    }
    else{
        return false
    }
}

function generateName(email){
    const name = email.split("@")
    return name[0]
}