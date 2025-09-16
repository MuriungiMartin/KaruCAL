#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68246 "REG-Registry Files List"
{
    CardPageID = "REG-Registry Files Card";
    PageType = List;
    SourceTable = UnknownTable61634;
    SourceTableView = where("File Status"=filter(New));

    layout
    {
        area(content)
        {
            repeater(Group)
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
            }
        }
        area(factboxes)
        {
            systempart(Control4;Notes)
            {
            }
            systempart(Control5;MyNotes)
            {
            }
            systempart(Control6;Links)
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
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;

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
                Image = Archive;
                Promoted = true;
                PromotedIsBig = true;

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

