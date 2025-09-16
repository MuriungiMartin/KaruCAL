#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69073 "ACA-Clearance Entries View"
{
    Caption = 'Clearance Approval Entries';
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61758;

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
                field("Student Intake";"Student Intake")
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
                field("Student ID";"Student ID")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
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
            action(clear_stud)
            {
                ApplicationArea = Basic;
                Caption = 'Clear Student';
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                ShortCutKey = 'F12';
                Visible = false;

                trigger OnAction()
                begin
                             if "Clearance Level Code"='' then Error('Nothing to clear!');
                              Clear(counted);
                             Clear(stringval);
                             if Confirm('Clear '+"Student ID",true)=false then Error('Cancelled!');
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
                               stringval:=stringval+'\                            CONTINUE?                               ';
                               stringval:=stringval+'\-----------------------*********************------------------------';
                             end else stringval:='Ensure that all the conditions required for clearance are met. Continue?';

                    if Confirm(stringval,true)=false then Error('Cancelled!');

                             enties.Reset;
                             enties.SetRange(enties."Clearance Level Code","Clearance Level Code");
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."Student ID","Student ID");
                             enties.SetFilter(enties."Clear By ID","Clear By ID");
                             if enties.Find('-') then begin
                             enties.Cleared:=true;
                             enties.Modify;
                             end;

                             enties.Reset;
                             enties.SetRange(enties."Clearance Level Code","Clearance Level Code");
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."Student ID","Student ID");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Open);
                             if enties.Find('-') then begin
                              repeat
                                begin
                                 enties."Last Date Modified":=Today;
                                 enties."Last Time Modified":=Time;
                                 enties.Status:=enties.Status::Cleared;
                                 enties.Modify;
                                end;
                              until enties.Next=0;
                             end;

                                  // Approval for the 1st Approval
                                  if "Priority Level"="priority level"::"1st Level" then begin
                                  //
                             enties.Reset;
                            // enties.SETRANGE(enties."Clearance Level Code","Clearance Level Code");
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."Student ID","Student ID");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Created);
                             enties.SetFilter(enties."Priority Level",'=%1',enties."priority level"::Normal);
                             if enties.Find('-') then begin
                              repeat
                                begin
                                 enties."Last Date Modified":=Today;
                                 enties."Last Time Modified":=Time;
                                 enties.Status:=enties.Status::Open;
                                 enties.Modify;
                                end;
                              until enties.Next=0;
                             end;
                                  end else if "Priority Level"="priority level"::Normal then begin
                                  //Search where Final Level and set to open
                             enties.Reset;
                             //enties.SETRANGE(enties."Clearance Level Code","Clearance Level Code");
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."Student ID","Student ID");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Open);
                             enties.SetFilter(enties."Priority Level",'=%1',enties."priority level"::Normal);
                             if not enties.Find('-') then begin
                             // If All other Clearances are done, Open the final Clearance
                             /////////////////////////////////////////////////////////////
                             //enties.SETRANGE(enties."Clearance Level Code","Clearance Level Code");
                             enties.Reset;
                             enties.SetRange(enties.Department,Department);
                             enties.SetRange(enties."Student ID","Student ID");
                             enties.SetFilter(enties.Status,'=%1',enties.Status::Created);
                             enties.SetFilter(enties."Priority Level",'=%1',enties."priority level"::"Final level");
                             if enties.Find('-') then begin
                              repeat
                                begin
                                 enties."Last Date Modified":=Today;
                                 enties."Last Time Modified":=Time;
                                 enties.Status:=enties.Status::Open;
                                 enties.Modify;
                                end;
                              until enties.Next=0;
                             end;

                             /////////////////////////////////////////////////////////////
                             end;
                                  end else if "Priority Level"="priority level"::"Final level" then begin
                                  // Change status of the clearance of the student card
                                if  cust.Get("Student ID") then begin
                                cust."Clearance Status":=cust."clearance status"::Cleared;
                                cust.Modify;
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
        enties: Record UnknownRecord61758;
        counted: Integer;
        stringval: Code[1024];
        conditions: Record UnknownRecord61759;
        cust: Record Customer;
}

