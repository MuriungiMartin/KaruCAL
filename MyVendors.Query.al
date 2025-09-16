#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 9151 "My Vendors"
{
    Caption = 'My Vendors';

    elements
    {
        dataitem(My_Vendor;"My Vendor")
        {
            filter(User_ID;"User ID")
            {
            }
            column(Vendor_No;"Vendor No.")
            {
            }
            dataitem(Vendor;Vendor)
            {
                DataItemLink = "No."=My_Vendor."Vendor No.";
                filter(Date_Filter;"Date Filter")
                {
                }
                column(Sum_Balance;Balance)
                {
                    Method = Sum;
                }
                column(Sum_Invoice_Amounts;"Invoice Amounts")
                {
                    Method = Sum;
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetRange(User_ID,UserId);
    end;
}

