import loginStyles from "../styles/Login.module.css"

const Form = () => {
  return (
    <>
        <div className={loginStyles.form_container}>
            <form className={loginStyles.form}>
                <small className={loginStyles.error_text}>Error Text here</small>
                <h3>Login Here</h3>

                <label htmlFor="email"><small>Email</small></label>
                <input type="email" id="email" className={loginStyles.form_input}/>

                <label htmlFor="password"><small>Password</small></label>
                <input type="password" id="password" className={loginStyles.form_input} />

                <button type="submit" className={loginStyles.form_button}>Login</button>
                
            </form>
        </div>
    </>
  )
}

export default Form
