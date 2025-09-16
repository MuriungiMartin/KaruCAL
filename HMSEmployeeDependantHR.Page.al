#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68643 "HMS Employee Dependant HR"
{
    PageType = Document;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address";"Residential Address")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field("Home Phone Number";"Home Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Cellular Phone Number";"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Work Phone Number";"Work Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Ext.";"Ext.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102760000;"HMS Employee Dependant SUB")
            {
                SubPageLink = "Employee No."=field("No.");
                SubPageView = where("Patient Type"=const(Employee),"Request Registration"=const(true),Blocked=const(true),Status=const("Request Made"));
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Approve Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Approve Request';

                    trigger OnAction()
                    begin
                        Line.Reset;
                        Line.SetRange(Line.Status,Line.Status::"Request Made");
                        Line.SetRange(Line."Employee No.","No.");
                        Line.SetRange(Line.Select,true);
                        if Line.Find('-') then
                          begin
                            if Confirm('Do you wish to Approve the Selected requests?',true)=false then begin exit end;
                            repeat
                              Line.Status:=Line.Status::"HOD HR Approved";
                              Line.Modify;
                            until Line.Next=0;
                            Message('The Selected Dependants Registration Request have been marked as Approved');
                          end;
                    end;
                }
                action("&Reject Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Reject Request';

                    trigger OnAction()
                    begin
                        Line.Reset;
                        Line.SetRange(Line.Status,Line.Status::"Request Made");
                        Line.SetRange(Line."Employee No.","No.");
                        Line.SetRange(Line.Select,true);
                        if Line.Find('-') then
                          begin
                            if Confirm('Do you wish to Reject the Selected requests?',true)=false then begin exit end;
                            repeat
                              Line.Status:=Line.Status::"HOD HR Rejected";
                              Line.Modify;
                            until Line.Next=0;
                            Message('The Selected Dependants Registration Request have been marked as REJECTED');
                          end;
                    end;
                }
            }
        }
    }

    var
        Line: Record UnknownRecord61402;
}

