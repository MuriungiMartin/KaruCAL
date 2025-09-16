#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60015 "ELECT-Cand. Applications List"
{
    CardPageID = "ELECT-Cand. Applications Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60005;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Candidate No.";"Candidate No.")
                {
                    ApplicationArea = Basic;
                }
                field("Candidate Names";"Candidate Names")
                {
                    ApplicationArea = Basic;
                }
                field("Position Code";"Position Code")
                {
                    ApplicationArea = Basic;
                }
                field("Position Category";"Position Category")
                {
                    ApplicationArea = Basic;
                }
                field("Electraol District Code";"Electraol District Code")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Campaign Slogan";"Campaign Slogan")
                {
                    ApplicationArea = Basic;
                }
                field("Campaign Statement";"Campaign Statement")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Approved;Approved)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Qualifies;Qualifies)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Approv)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F9';

                trigger OnAction()
                var
                    ELECTCandidates: Record UnknownRecord60006;
                begin
                    CalcFields(Qualifies);
                    if Approved then Error('Applicant already cleared');
                    if not Qualifies then Error('Applicant does not qualify');
                    if Confirm('Clear Applicant?',true)=true then begin
                      Approved:=true;
                      Modify;
                      // Move Applicant to applications
                      ELECTCandidates.Reset;
                      ELECTCandidates.SetRange("Election Code",Rec."Election Code");
                      ELECTCandidates.SetRange("Candidate No.",Rec."Candidate No.");
                      if not ELECTCandidates.Find('-') then  begin
                        ELECTCandidates.Init;
                        ELECTCandidates."Election Code":=Rec."Election Code";
                        ELECTCandidates."Candidate No.":=Rec."Candidate No.";
                        ELECTCandidates."Position Code":=Rec."Position Code";
                        ELECTCandidates."Position Category":=Rec."Position Category";
                        ELECTCandidates."Electral District Code":=Rec."Electraol District Code";
                        ELECTCandidates."Department Code":=Rec."Department Code";
                        ELECTCandidates."School Code":=Rec."School Code";
                        ELECTCandidates."Campus Code":=Rec."Campus Code";
                        ELECTCandidates."Campaign Slogan":=Rec."Campaign Slogan";
                        ELECTCandidates."Campaign Statement":=Rec."Campaign Statement";
                        ELECTCandidates."Candidate Names":=Rec."Candidate Names";
                        ELECTCandidates.Insert;
                      end;
                      Message('Applicant Cleared');
                      end else Error('Cancelled');
                end;
            }
        }
    }
}

