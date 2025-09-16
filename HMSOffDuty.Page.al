#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77734 "HMS Off Duty"
{
    PageType = List;
    SourceTable = UnknownTable70085;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Treatment No.";"Treatment No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No";"Staff No")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Name";"Staff Name")
                {
                    ApplicationArea = Basic;
                }
                field("Off Duty Start Date";"Off Duty Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Contact person";"Contact person")
                {
                    ApplicationArea = Basic;
                }
                field("Off Duty Reason Reason";"Off Duty Reason Reason")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("No of days";"No of days")
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
            action("&Register Referral")
            {
                ApplicationArea = Basic;
                Caption = '&Register Referral';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Referral: Record UnknownRecord70085;
                    TreatmentHeader: Record UnknownRecord61407;
                begin
                    if Confirm('Register Off duty?',false)=false then begin exit end;

                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get("Treatment No.") then
                      begin
                        Referral.Init;
                          Referral."Treatment No.":="Treatment No.";
                          Referral."Staff No":=TreatmentHeader."Employee No.";
                          Referral."Patient No":=TreatmentHeader."Patient No.";
                          //Referral."Off Duty Start Date":="Date Referred";

                        Referral.Insert();
                      end;
                end;
            }
        }
    }
}

