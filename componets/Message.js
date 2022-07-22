import formStyles from "../styles/Form.module.css"

const Message = ({message, category}) =>{
   return (
    <div>
      <span className={formStyles.message} style={{ "backgroundColor": category, "padding": message ? "3px": "0px" }}>{message}</span>
    </div>
  )
}
export default Message
