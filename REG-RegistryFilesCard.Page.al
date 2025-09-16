#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68245 "REG-Registry Files Card"
{
    PageType = Card;
    SourceTable = UnknownTable61634;
    SourceTableView = where("File Status"=filter(New));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("File No.";"File No.")
                {
                    ApplicationArea = Basic;
                }
                field("File Subject/Description";"File Subject/Description")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("File Type";"File Type")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Allowable Files";"Maximum Allowable Files")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Issue";"Date of Issue")
                {
                    ApplicationArea = Basic;
                }
                field("Issuing Officer";"Issuing Officer")
                {
                    ApplicationArea = Basic;
                }
                field("Circulation Reason";"Circulation Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Return Date";"Expected Return Date")
                {
                    ApplicationArea = Basic;
                }
                field("Receiving Officer";"Receiving Officer")
                {
                    ApplicationArea = Basic;
                }
                field("Delivery Officer";"Delivery Officer")
                {
                    ApplicationArea = Basic;
                }
                field("File Status";"File Status")
                {
                    ApplicationArea = Basic;
                }
                field("Dispatch Status";"Dispatch Status")
                {
                    ApplicationArea = Basic;
                }
                field("Issuing Office Name";"Issuing Office Name")
                {
                    ApplicationArea = Basic;
                }
                field("Recieving Officer Name";"Recieving Officer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Delivery Officer Name";"Delivery Officer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Folio No";"Folio No")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18;Notes)
            {
            }
            systempart(Control19;MyNotes)
            {
            }
            systempart(Control20;Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Dispatch ")
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch File';

                trigger OnAction()
                begin
                           if (Confirm('Dispatch File?',true)=false) then Error('Cancelled!');
                           "Dispatch Status":="dispatch status"::Dispatched;
                           Modify;
                           Message('File Dispatched!')
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Caption = 'Archive File';

                trigger OnAction()
                begin
                    if Confirm('Archive File?',false)=false then exit;

                                                   "File Status":="file status"::Archived;
                                                   Modify;
                                                   Message('File archived!');
                end;
            }
        }
    }
}

