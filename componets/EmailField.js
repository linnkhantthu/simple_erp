import formStyles from "../styles/Form.module.css"

const EmailField = ({message}) => {
  return (
    <>
        <label htmlFor="email"><small>Email</small></label>
        <input type="email" id="email" name="email" className={formStyles.form_input} required/>
        <small className={formStyles.error_text}>{message}</small>
    </>
  )
}

export default EmailField