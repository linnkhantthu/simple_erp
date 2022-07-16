import formStyles from "../styles/Form.module.css"

const PasswordField = () => {
  return (
    <>
        <label htmlFor="Password"><small>Password</small></label>
        <input type="Password" id="Password" className={formStyles.form_input}/>
        <small className={formStyles.error_text}>Wrong Password</small>
    </>
  )
}

export default PasswordField