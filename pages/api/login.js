import { withIronSessionApiRoute } from "iron-session/next"
import { PrismaClient } from '@prisma/client'

export default withIronSessionApiRoute(
  async function loginRoute(req, res) {
    let status_code
    let status
    let message
    let email
    
    if(req.method === 'POST'){
      const user = await checkLogin(email, password)
      const data = req.body
      email = data.email
      const password = data.password
      status_code = 200
      if(email === "linnkhantthu1999mdy@gmail.com" && password === "12345678"){
        email = email
        status = true
        message = "Logged in as " + email
      }
      else{
        status = false
        message = "Email or Password is incorrect"
      }
    }
    else{
      status_code = 404
      status = false
      message = "Invalid request"
    }
    if(status === true){
      req.session.user = {
        id: 1,
        email: email,
      }
      await req.session.save();
    }
    res.send({status: status, message: message})
  },
  {
    cookieName: "simple_erp_user",
    password: "knjaufhiuncuihnfcsjhjisnfucnughfbc",
    cookieOptions: {
      secure: process.env.NODE_ENV === "production"
    }
  }
)

async function checkLogin(email, password){
  const prisma = new PrismaClient()
  const user = await prisma.user.findFirst({
    where:{
      email: email,
      password: password
    }
  })
  await prisma.$disconnect()
  return user
}