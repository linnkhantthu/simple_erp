import { PrismaClient } from '@prisma/client'

export default function handler(req, res) {
    
    res.status(200).json({ message: 'register route' })
}

async function register(name, email, password){
    const user = await prisma.user.create({
        data: {
            name: 'Elsa Prisma',
            email: email,
            password: password,
        },
      })
  await prisma.$disconnect()
  return user
}