#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7710 "ADCS Users"
{
    ApplicationArea = Basic;
    Caption = 'ADCS Users';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "ADCS User";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of an ADCS user.';
                }
                field(Password;Password)
                {
                    ApplicationArea = Basic;
                    Caption = 'Password';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the password of an ADCS user.';
                }
            }
        }
    }

    actions
    {
    }
}

