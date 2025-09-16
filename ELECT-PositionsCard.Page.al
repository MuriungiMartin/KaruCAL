#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60001 "ELECT-Positions Card"
{
    PageType = Card;
    SourceTable = UnknownTable60001;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Election Code";"Election Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Position Category";"Position Category")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Position Code";"Position Code")
                {
                    ApplicationArea = Basic;
                }
                field("Position Description";"Position Description")
                {
                    ApplicationArea = Basic;
                }
                field("isDelegate?";"isDelegate?")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Nominees/Voter";"Number of Nominees/Voter")
                {
                    ApplicationArea = Basic;
                }
                field("Highest Nominee No. One Gender";"Highest Nominee No. One Gender")
                {
                    ApplicationArea = Basic;
                }
                field("Position Notes";"Position Notes")
                {
                    ApplicationArea = Basic;
                }
                field("Position Scope";"Position Scope")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                          "Electral District":='';
                          "Campus Code":='';
                          "Department Code":='';
                          "School Code":='';
                          EnableElectralDist:=false;
                          EnableDept:=false;
                          EnableCampus:=false;
                          EnableSchool:=false;
                        if  "Position Scope"="position scope"::"Campus Position" then begin
                          EnableCampus:=true;
                          end else if "Position Scope"="position scope"::"School Position" then begin
                          EnableSchool:=true;
                          end else if "Position Scope"="position scope"::"Departmental Position" then begin
                          EnableDept:=true;
                          end else if "Position Scope"="position scope"::"Electral District Position" then begin
                          EnableElectralDist:=true;
                          end;
                    end;
                }
                field("Electral District";"Electral District")
                {
                    ApplicationArea = Basic;
                    Editable = EnableElectralDist;
                    Enabled = EnableElectralDist;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                    Editable = EnableCampus;
                    Enabled = EnableCampus;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                    Editable = EnableSchool;
                    Enabled = EnableSchool;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Editable = EnableDept;
                    Enabled = EnableDept;
                }
                field("Position Approved";"Position Approved")
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Candidates";"No. Of Candidates")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("No. of Applications";"No. of Applications")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Votes Cast";"Votes Cast")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Highest Score";"Highest Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("First Position";"First Position")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Count Highest Positions";"Count Highest Positions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Tie Exists";"Tie Exists")
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
    }

    var
        EnableElectralDist: Boolean;
        EnableDept: Boolean;
        EnableSchool: Boolean;
        EnableCampus: Boolean;
}

