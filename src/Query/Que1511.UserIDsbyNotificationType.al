#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 1511 "User IDs by Notification Type"
{
    Caption = 'User IDs by Notification Type';

    elements
    {
        dataitem(Notification_Entry;"Notification Entry")
        {
            column(Recipient_User_ID;"Recipient User ID")
            {
            }
            column(Type;Type)
            {
            }
            column(Count_)
            {
                Method = Count;
            }
        }
    }
}

