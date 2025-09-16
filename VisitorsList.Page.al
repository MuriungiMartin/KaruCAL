#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50050 "Visitors List"
{
    CardPageID = "Visitors Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Automated Notification Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID No.";"ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("Full Names";"Full Names")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Date";"Reg. Date")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Time";"Reg. Time")
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("Registered By";"Registered By")
                {
                    ApplicationArea = Basic;
                }
                field("No. of Visits";"No. of Visits")
                {
                    ApplicationArea = Basic;
                }
                field("Date Filter";"Date Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Time Filter";"Time Filter")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Reports)
            {
                Caption = 'Statements';
                action("Statement (Summary)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement (Summary)';
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        visCard.Reset;
                        visCard.SetRange("ID No.","ID No.");
                        if visCard.Find('-') then begin
                            Report.Run(50052,true,false,visCard);
                          end;
                    end;
                }
                action("Statement (Detailed)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Statement (Detailed)';
                    Image = Report2;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        visCard.Reset;
                        visCard.SetRange("ID No.","ID No.");
                        if visCard.Find('-') then begin
                            Report.Run(50053,true,false,visCard);
                          end;
                    end;
                }
            }
        }
    }

    var
        visCard: Record "Automated Notification Setup";
}

