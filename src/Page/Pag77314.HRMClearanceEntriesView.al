#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77314 "HRM-Clearance Entries View"
{
    Caption = 'HRM Clearance Approval Entries';
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable77306;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Clearance Level Code";"Clearance Level Code")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Initiated By";"Initiated By")
                {
                    ApplicationArea = Basic;
                }
                field("Initiated Date";"Initiated Date")
                {
                    ApplicationArea = Basic;
                }
                field("Initiated Time";"Initiated Time")
                {
                    ApplicationArea = Basic;
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Last Time Modified";"Last Time Modified")
                {
                    ApplicationArea = Basic;
                }
                field("Clear By ID";"Clear By ID")
                {
                    ApplicationArea = Basic;
                }
                field(Cleared;Cleared)
                {
                    ApplicationArea = Basic;
                }
                field("Priority Level";"Priority Level")
                {
                    ApplicationArea = Basic;
                }
                field("PF. No.";"PF. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
            action(ClearStaff)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Staff';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F12';

                trigger OnAction()
                var
                    ACAClearanceApprovalEntries: Record UnknownRecord77306;
                    UserSetup: Record "User Setup";
                begin
                             if "Clearance Level Code"='' then Error('Nothing to clear!');
                              Clear(counted);
                             Clear(stringval);
                             if Confirm('Clear '+"PF. No.",true)=false then Error('Cancelled!');
                             conditions.Reset;
                             conditions.SetRange(conditions."Clearance Level Code","Clearance Level Code");
                             conditions.SetFilter(conditions."Condition to Check",'<>%1','');
                             if conditions.Find('-') then begin
                             stringval:='\-----------------------***** ATTENTION *****------------------------';
                               stringval:=stringval+'\Ensure that the following conditions are met';
                               repeat
                               begin
                                 stringval:=stringval+'\'+Format(conditions.Sequence)+'). '+conditions."Condition to Check";
                               end;
                               until conditions.Next=0;
                               stringval:=stringval+'\'+'                             CONTINUE?                              ';
                               stringval:=stringval+'\-----------------------*********************------------------------';
                             end else stringval:='Ensure that all the conditions required for clearance are met. Continue?';

                    if Confirm(stringval,true)=false then Error('Cancelled!');

                             enties.Reset;
                             enties.SetRange(enties."Clearance Level Code","Clearance Level Code");
                             enties.SetRange(enties."PF. No.","PF. No.");
                             enties.SetFilter(enties."Clear By ID",UserId);
                             if enties.Find('-') then begin
                                 enties.Cleared:=true;
                                 enties."Last Date Modified":=Today;
                                 enties."Last Time Modified":=Time;
                                 enties.Status:=enties.Status::Cleared;
                                 enties.Modify;
                             enties2.Reset;
                             enties2.SetRange(enties2."Clearance Level Code","Clearance Level Code");
                             enties2.SetRange(enties2."PF. No.","PF. No.");
                             enties2.SetRange(enties2.Sequence,Sequence);
                             if enties2.Find('-') then begin
                               repeat
                                  begin
                                 enties2."Last Date Modified":=Today;
                                 enties2."Last Time Modified":=Time;
                                 enties2.Status:=enties.Status::Cleared;
                                 enties2.Modify;
                                  end;
                                 until enties2.Next=0;
                               end;
                             end;

                                  // Approval for the 1st Approval
                                  if "Priority Level"="priority level"::"1st Level" then begin
                             enties.Reset;
                             enties.SetRange(enties."PF. No.","PF. No.");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Created);
                             enties.SetFilter(enties."Priority Level",'=%1',enties."priority level"::Normal);
                             if enties.Find('-') then begin
                              repeat
                                begin
                                 enties."Last Date Modified":=Today;
                                 enties."Last Time Modified":=Time;
                                 enties.Status:=enties.Status::Open;
                                 enties.Modify;
                                 ///////////////////////////////////////////////////////////////////////////////////
                            UserSetup.Reset;
                            UserSetup.SetRange("User ID",enties."Clear By ID");
                            if UserSetup.Find('-') then begin

                              webportals.SendEmailEasy('Hi ',UserSetup.UserName,'A Staff clearance request has been sent to your email for Staff No.:'+Rec."PF. No.",
                              'Kindly expedite.','This is a system generated mail. Kindly do not respond. Unless you want to talk to a Robot!',
                              'In case of Challenges, Kindly Talk to the ICT department',UserSetup."E-Mail",'STAFF CLEARANCE APPROVAL');
                              end;
                                 ///////////////////////////////////////////////////////////////////////////////////
                                end;
                              until enties.Next=0;
                             end;
                                  end else if "Priority Level"="priority level"::Normal then begin
                                  //Search where Final Level and set to open
                             enties.Reset;
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."PF. No.","PF. No.");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Open);
                             enties.SetFilter(enties."Priority Level",'=%1',enties."priority level"::Normal);
                             if not enties.Find('-') then begin
                             // If All other Clearances are done, Open the final Clearance
                             /////////////////////////////////////////////////////////////
                             //enties.SETRANGE(enties."Clearance Level Code","Clearance Level Code");
                             ACAClearanceApprovalEntries.Reset;
                         //    ACAClearanceApprovalEntries.SETRANGE(ACAClearanceApprovalEntries.Department,Department);
                             ACAClearanceApprovalEntries.SetRange(ACAClearanceApprovalEntries."PF. No.","PF. No.");
                             ACAClearanceApprovalEntries.SetFilter(ACAClearanceApprovalEntries.Status,'=%1',ACAClearanceApprovalEntries.Status::Created);
                             ACAClearanceApprovalEntries.SetFilter(ACAClearanceApprovalEntries."Priority Level",'=%1',
                                      ACAClearanceApprovalEntries."priority level"::Finance);
                             if ACAClearanceApprovalEntries.Find('-') then begin
                              repeat
                                begin
                                 ACAClearanceApprovalEntries."Last Date Modified":=Today;
                                 ACAClearanceApprovalEntries."Last Time Modified":=Time;
                                 ACAClearanceApprovalEntries.Status:=ACAClearanceApprovalEntries.Status::Open;
                                 ACAClearanceApprovalEntries.Modify;
                                 ///////////////////////////////////////////////////////////////////////////////////
                            UserSetup.Reset;
                            UserSetup.SetRange("User ID",ACAClearanceApprovalEntries."Clear By ID");
                            if UserSetup.Find('-') then begin
                              webportals.SendEmailEasy('Hi ',UserSetup.UserName,'A Staff clearance requeste has been sent to your email for Staff No.:'+Rec."PF. No.",
                              'Kindly expedite.','This is a system generated mail. Kindly do not respond. Unless you want to talk to a Robot!',
                              'In case of Challenges, Kindly Talk to the ICT department',UserSetup."E-Mail",'STAFF CLEARANCE APPROVAL');
                              end;
                                 ///////////////////////////////////////////////////////////////////////////////////
                                end;
                              until ACAClearanceApprovalEntries.Next=0;
                             end;

                             /////////////////////////////////////////////////////////////
                             end;
                                  end else if "Priority Level"="priority level"::Finance then begin
                                  //Search where Final Level and set to open
                             enties.Reset;
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."PF. No.","PF. No.");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Open);
                             enties.SetFilter(enties."Priority Level",'=%1',enties."priority level"::Finance);
                             if not enties.Find('-') then begin
                             // If All other Clearances are done, Open the final Clearance
                             /////////////////////////////////////////////////////////////
                             //enties.SETRANGE(enties."Clearance Level Code","Clearance Level Code");
                             ACAClearanceApprovalEntries.Reset;
                         //    ACAClearanceApprovalEntries.SETRANGE(ACAClearanceApprovalEntries.Department,Department);
                             ACAClearanceApprovalEntries.SetRange(ACAClearanceApprovalEntries."PF. No.","PF. No.");
                             ACAClearanceApprovalEntries.SetFilter(ACAClearanceApprovalEntries.Status,'=%1',ACAClearanceApprovalEntries.Status::Created);
                             ACAClearanceApprovalEntries.SetFilter(ACAClearanceApprovalEntries."Priority Level",'=%1',
                                      ACAClearanceApprovalEntries."priority level"::"Final level");
                             if ACAClearanceApprovalEntries.Find('-') then begin
                              repeat
                                begin
                                 ACAClearanceApprovalEntries."Last Date Modified":=Today;
                                 ACAClearanceApprovalEntries."Last Time Modified":=Time;
                                 ACAClearanceApprovalEntries.Status:=ACAClearanceApprovalEntries.Status::Open;
                                 ACAClearanceApprovalEntries.Modify;
                                 ///////////////////////////////////////////////////////////////////////////////////
                            UserSetup.Reset;
                            UserSetup.SetRange("User ID",ACAClearanceApprovalEntries."Clear By ID");
                            if UserSetup.Find('-') then begin
                              webportals.SendEmailEasy('Hi ',UserSetup.UserName,'A Staff clearance requeste has been sent to your email for Staff No.:'+Rec."PF. No.",
                              'Kindly expedite.','This is a system generated mail. Kindly do not respond. Unless you want to talk to a Robot!',
                              'In case of Challenges, Kindly Talk to the ICT department',UserSetup."E-Mail",'STAFF CLEARANCE APPROVAL');
                              end;
                                 ///////////////////////////////////////////////////////////////////////////////////
                                end;
                              until ACAClearanceApprovalEntries.Next=0;
                             end;

                             /////////////////////////////////////////////////////////////
                             end;
                                  end  else if "Priority Level"="priority level"::"Final level" then begin
                                  // Change status of the clearance of the student card
                                if  HREmployee.Get("PF. No.") then begin
                                HREmployee."Clearance Status":=HREmployee."clearance status"::Cleared;
                                HREmployee.Modify;
                                 ///////////////////////////////////////////////////////////////////////////////////
                                 if HREmployee."E-Mail"<>'' then begin
                              webportals.SendEmailEasy('Hi ',HREmployee."First Name"+' '+HREmployee."Middle Name"+' '+HREmployee."Last Name",' Your application for clearance has been Approved',
                              'Download your signed clearance form from the portal','This is a system generated mail. Kindly do not respond. Unless you want to talk to a Robot!',
                              'In case of Challenges, Kindly Talk to your department head',UserSetup."E-Mail",'STAFF APPROVED CLEARANCE');
                              end;
                                 ///////////////////////////////////////////////////////////////////////////////////
                                end;
                                  end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
          // SETFILTER("Clear By ID",USERID);
    end;

    var
        enties: Record UnknownRecord77306;
        counted: Integer;
        stringval: Code[1024];
        conditions: Record UnknownRecord77307;
        HREmployee: Record UnknownRecord61188;
        webportals: Codeunit webportals;
        enties2: Record UnknownRecord77306;
}

