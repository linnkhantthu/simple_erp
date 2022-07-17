import formStyles from "../styles/Form.module.css"

const PasswordField = ({message}) => {
  return (
    <>
        <label htmlFor="Password"><small>Password</small></label>
        <input type="Password" id="Password" name="password" className={formStyles.form_input} required/>
        <small className={formStyles.error_text}>{message}</small>
    </>
  )
}

export default PasswordField