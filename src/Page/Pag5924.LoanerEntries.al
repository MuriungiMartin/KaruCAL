#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5924 "Loaner Entries"
{
    ApplicationArea = Basic;
    Caption = 'Loaner Entries';
    DataCaptionFields = "Loaner No.";
    Editable = false;
    PageType = List;
    SourceTable = "Loaner Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number that is assigned to this entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the document type of the entry is a quote or order.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service document specifying the service item you have replaced with the loaner.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item that you have replaced with the loaner.';
                }
                field("Service Item Line No.";"Service Item Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item line for which you have lent the loaner.';
                }
                field("Loaner No.";"Loaner No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the loaner.';
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item group code of the service item that you have replaced with the loaner.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer to whom you have lent the loaner.';
                }
                field("Date Lent";"Date Lent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you lent the loaner.';
                }
                field("Time Lent";"Time Lent")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when you lent the loaner.';
                }
                field("Date Received";"Date Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when you received the loaner.';
                }
                field("Time Received";"Time Received")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time when you received the loaner.';
                }
                field(Lent;Lent)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the loaner is lent.';
                }
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
    }
}

