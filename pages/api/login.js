import { withIronSessionApiRoute } from "iron-session/next"
import { PrismaClient } from '@prisma/client'

export default withIronSessionApiRoute(
  async function loginRoute(req, res) {
    let status_code
    let status
    let message
    let email
    
    if(req.method === 'POST'){
      const data = req.body
      email = data.email
      const password = data.password
      const user = await checkLogin(email, password)
      if(user){
        status_code = 200
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

export async function checkLogin(email, password){
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