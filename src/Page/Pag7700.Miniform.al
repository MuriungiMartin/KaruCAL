#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7700 Miniform
{
    Caption = 'Miniform';
    DataCaptionFields = "Code";
    PageType = ListPlus;
    SourceTable = "Miniform Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a unique code for a specific miniform.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies your description of the miniform with the code on the header.';
                }
                field("Form Type";"Form Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the form type of the miniform.';
                }
                field("No. of Records in List";"No. of Records in List")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of records that will be sent to the handheld if the miniform on the header is either Selection List or Data List.';
                }
                field("Handling Codeunit";"Handling Codeunit")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the codeunit containing the code that handles this miniform.';
                }
                field("Next Miniform";"Next Miniform")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which form will be shown next when a selection is made in a Data List form or when the last field is entered on a Card form.';
                }
                field("Start Miniform";"Start Miniform")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this field is the first miniform that will be shown to the user when starting up a handheld.';
                }
            }
            part(Control9;"Miniform Subform")
            {
                SubPageLink = "Miniform Code"=field(Code);
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Mini Form")
            {
                Caption = '&Mini Form';
                Image = MiniForm;
                action("&Functions")
                {
                    ApplicationArea = Basic;
                    Caption = '&Functions';
                    Image = "Action";
                    RunObject = Page "Miniform Functions";
                    RunPageLink = "Miniform Code"=field(Code);
                }
            }
        }
    }
}

