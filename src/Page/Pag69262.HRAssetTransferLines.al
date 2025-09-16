#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69262 "HR Asset Transfer Lines"
{
    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable69262;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field("Asset Bar Code";"Asset Bar Code")
                {
                    ApplicationArea = Basic;
                }
                field("Asset Description";"Asset Description")
                {
                    ApplicationArea = Basic;
                }
                field("FA Location";"FA Location")
                {
                    ApplicationArea = Basic;
                }
                field("Asset Serial No";"Asset Serial No")
                {
                    ApplicationArea = Basic;
                }
                field("Book Value";"Book Value")
                {
                    ApplicationArea = Basic;
                }
                field("Responsible Employee Code";"Responsible Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("New Responsible Employee Code";"New Responsible Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("New Employee Name";"New Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Caption = '<Current Regional Office>';
                }
                field("New Global Dimension 1 Code";"New Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Caption = ' <Current Project Code>';
                }
                field("New Global Dimension 2 Code";"New Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Caption = '<New Project Code>';
                }
                field("New  Dimension 2 Name";"New  Dimension 2 Name")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 3 Code";"Global Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("New Global Dimension 3 Code";"New Global Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                }
                field("New  Dimension 3 Name";"New  Dimension 3 Name")
                {
                    ApplicationArea = Basic;
                }
                field("Is Asset Expected Back?";"Is Asset Expected Back?")
                {
                    ApplicationArea = Basic;
                }
                field("New Asset Location";"New Asset Location")
                {
                    ApplicationArea = Basic;
                }
                field("Reason for Transfer";"Reason for Transfer")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Transfer)
            {
                ApplicationArea = Basic;
                Image = TaskPage;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
            }
        }
    }
}

