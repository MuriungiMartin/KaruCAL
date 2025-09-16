#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68971 "ACA-Student Clearance (Open)"
{
    Caption = 'Student Clearance (Open)';
    CardPageID = "ACA-Clearance View Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Type"=const(Student),
                            "Clearance Status"=filter(=open));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Semester";"Clearance Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Academic Year";"Clearance Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Programme End Date";"Programme End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Student)
            {
                Caption = 'Student';
                action(initiateClearance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Initiate Clearance';
                    Image = "Action";
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ClearLevela: Record UnknownRecord61754;
                        ClearTemplates: Record UnknownRecord61755;
                        ClearDepTemplates: Record UnknownRecord61756;
                        ClearStandardApp: Record UnknownRecord61757;
                        cust: Record Customer;
                        ClearEntries: Record UnknownRecord61758;
                    begin
                         ACACourseRegistration.Reset;
                         ACACourseRegistration.SetRange("Student No.",Rec."No.");
                         ACACourseRegistration.SetFilter(Programme,'<>%1','');
                         if ACACourseRegistration.Find('-') then begin
                           end;
                           progs.Reset;
                           progs.SetRange(Code,ACACourseRegistration.Programme);
                           if progs.Find('-') then;
                           "Global Dimension 2 Code":=progs."Department Code";
                         sems.Reset;
                         sems.SetRange(sems."Current Semester",true);
                         if sems.Find('-') then
                         if not (sems.Code='') then
                         "Clearance Semester":=sems.Code;
                         "Programme End Date":=ACACourseRegistration."Registration Date";
                         acadYear.Reset;
                         acadYear.SetRange(acadYear.Current,true);
                         if acadYear.Find('-') then
                         if not (acadYear.Code='') then
                         "Clearance Academic Year":=acadYear.Code;
                         "Clearance Reason":="clearance reason"::Graduation;
                         Modify;

                          CalcFields("Balance (LCY)");
                         // CALCFIELDS("Refund on PV");
                           if ("Balance (LCY)">0) then Error('The student''s balance must be zero (0).\The Balance is '+Format("Balance (LCY)"));
                          if not (Confirm('Initiate student clearance for '+"No."+': '+Name,false)=true) then Error('Cancelled!');
                         //TESTFIELD("Clearance Reason");
                         TestField("Global Dimension 2 Code");
                         //TESTFIELD("Clearance Semester");
                         //TESTFIELD("Clearance Academic Year");
                         TestField("Current Programme");
                         TestField("Programme End Date");
                         //TESTFIELD("Intake Code");
                         deptemp.Reset;
                         deptemp.SetRange(deptemp."Clearance Level Code",'HOD');
                         deptemp.SetRange(deptemp.Department,"Global Dimension 2 Code");
                         if not (deptemp.Find('-')) then Error('Departmental approver for '''+"Global Dimension 2 Code"+''' missing');
                        ClearLevela.Reset;
                        ClearLevela.SetRange(ClearLevela.Status,ClearLevela.Status::Active);
                        ClearLevela.SetFilter(ClearLevela."Priority Level",'=%1',ClearLevela."priority level"::"1st Level");
                        if not (ClearLevela.Find('-')) then Error('1st Approval Level is missing!');

                        ClearLevela.Reset;
                        ClearLevela.SetRange(ClearLevela.Status,ClearLevela.Status::Active);
                        ClearLevela.SetFilter(ClearLevela."Priority Level",'=%1',ClearLevela."priority level"::Finance);
                        if not (ClearLevela.Find('-')) then Error('Finance Approval Level is missing!');


                        ClearLevela.Reset;
                        ClearLevela.SetRange(ClearLevela.Status,ClearLevela.Status::Active);
                        ClearLevela.SetFilter(ClearLevela."Priority Level",'=%1',ClearLevela."priority level"::"Final level");
                        if not (ClearLevela.Find('-')) then Error('Final Approval Level is missing!');



                        ClearLevela.Reset;
                        ClearLevela.SetRange(ClearLevela.Status,ClearLevela.Status::Active);
                        if ClearLevela.Find('-') then begin //5
                          repeat
                            begin  //4
                              if (ClearLevela.Standard) then begin  //3
                              // Pick from the standard Approvals and insert into the Entries table
                              ClearStandardApp.Reset;
                              ClearStandardApp.SetRange(ClearStandardApp."Clearance Level Code",ClearLevela."Clearance Level Code");
                              ClearStandardApp.SetFilter(ClearStandardApp.Active,'=%1',true);
                              if ClearStandardApp.Find('-') then begin //2
                                repeat  // Rep1
                                begin //1
                                    ClearEntries.Init;
                                      ClearEntries."Clearance Level Code":= ClearStandardApp."Clearance Level Code";
                                      ClearEntries.Department:="Global Dimension 2 Code";
                                      ClearEntries."Student ID":="No.";
                                      ClearEntries."Clear By ID":=ClearStandardApp."Clear By Id";
                                      ClearEntries."Initiated By":=UserId;
                                      ClearEntries."Initiated Date":=Today;
                                      ClearEntries."Initiated Time":=Time;
                                      ClearEntries."Last Date Modified":=Today;
                                      ClearEntries."Last Time Modified":=Time;
                                      ClearEntries.Cleared:=false;
                                      ClearEntries."Priority Level":=ClearLevela."Priority Level";
                                      ClearEntries."Academic Year":="Clearance Academic Year";
                                      ClearEntries.Semester:="Clearance Semester";
                                      if ClearLevela."Priority Level"=ClearLevela."priority level"::"1st Level" then begin
                                      ClearEntries.Status:=ClearEntries.Status::Open;
                                        ClearEntries.Insert;
                                usersetup.Reset;
                                usersetup.SetRange("User ID",ClearStandardApp."Clear By Id");
                                if usersetup.Find('-') then begin

                                  webportals.SendEmailEasy('Hi ',usersetup.UserName,'A Student clearance request has been sent to your email for student:'+Rec."No.",
                                  'Kindly expedite.','This is a system generated mail that does not require a response unless you want to talk to a Robot!',
                                  'In case of challenges, kindly contact the ICT Directorate via ict@karu.ac.ke',usersetup."E-Mail",'STUDENT CLEARANCE APPROVAL');
                                  end;
                                      end else begin  ClearEntries.Status:=ClearEntries.Status::Created;
                                    ClearEntries.Insert;
                                        end;

                                end; //1
                                until ClearStandardApp.Next =0; //  Rep1
                              end else Error('Setup for Clearance Templates not found;');  // 2
                              end else begin    //3
                                // Check templates for the related Clearance Approvals
                                ClearTemplates.Reset;
                                ClearTemplates.SetRange(ClearTemplates."Clearance Level Code",ClearLevela."Clearance Level Code");
                                ClearTemplates.SetRange(ClearTemplates.Department,"Global Dimension 2 Code");
                                ClearTemplates.SetFilter(ClearTemplates.Active,'=%1',true);
                                if ClearTemplates.Find('-') then begin  //6
                                  ClearDepTemplates.Reset;
                                 ClearDepTemplates.SetRange(ClearDepTemplates."Clearance Level Code",ClearLevela."Clearance Level Code");
                                 ClearDepTemplates.SetRange(ClearDepTemplates.Department,"Global Dimension 2 Code");
                                 ClearDepTemplates.SetFilter(ClearDepTemplates.Active,'=%1',true);
                                  if ClearDepTemplates.Find('-') then begin//7
                                  repeat
                                  begin
                                    ClearEntries.Init;
                                      ClearEntries."Clearance Level Code":= ClearDepTemplates."Clearance Level Code";
                                      ClearEntries.Department:="Global Dimension 2 Code";
                                      ClearEntries."Student ID":="No.";
                                      ClearEntries."Clear By ID":=ClearDepTemplates."Clear By Id";
                                      ClearEntries."Initiated By":=UserId;
                                      ClearEntries."Initiated Date":=Today;
                                      ClearEntries."Initiated Time":=Time;
                                      ClearEntries."Last Date Modified":=Today;
                                      ClearEntries."Last Time Modified":=Time;
                                      ClearEntries.Cleared:=false;
                                      ClearEntries."Priority Level":=ClearLevela."Priority Level";
                                      ClearEntries."Academic Year":="Clearance Academic Year";
                                      ClearEntries.Semester:="Clearance Semester";
                                      if ClearLevela."Priority Level"=ClearLevela."priority level"::"1st Level" then begin
                                      ClearEntries.Status:=ClearEntries.Status::Open;
                                        ClearEntries.Insert;
                                usersetup.Reset;
                                usersetup.SetRange("User ID",ClearStandardApp."Clear By Id");
                                if usersetup.Find('-') then begin
                                  webportals.SendEmailEasy('Hi ',usersetup.UserName,'A Student clearance requeste has been sent to your email for student:'+Rec."No.",
                                  'Kindly expedite.','This is a system generated mail. Kindly do not respond. Unless you want to talk to a Robot!',
                                  'In case of Challenges, Kindly Talk to the ICT department',usersetup."E-Mail",'STUDENT CLEARANCE APPROVAL');
                                  end;
                                     end else begin ClearEntries.Status:=ClearEntries.Status::Created;
                                    ClearEntries.Insert;
                                       end;
                                    end;
                                    until ClearDepTemplates.Next=0;
                                  end;//7
                                end //6
                              end;   //3
                            end;  //4
                          until ClearLevela.Next=0;
                        end else Error('No Clearance levels specified.');  //5
                        Message('Clearance Initiated successfully.');
                        "Clearance Status":="clearance status"::Active;
                        Modify;
                    end;
                }
                action(printForm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Clearance Form';
                    Image = PrintVoucher;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                         if "Clearance Status"="clearance status"::open then Error('Initiate the clearance process before printing the clearance form');
                        ACAClearanceApprovalEntries.Reset;
                        ACAClearanceApprovalEntries.SetRange("Student ID","No.");
                        if ACAClearanceApprovalEntries.Find('-') then
                        Report.Run(51675,true,false,ACAClearanceApprovalEntries);
                    end;
                }
                action(stdId)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student ID Card';
                    Image = Picture;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        stud.Reset;
                        stud.SetRange(stud."No.","No.");
                        if stud.Find('+') then
                        Report.Run(51729,true,false,stud);
                         // ERROR('Yap');
                    end;
                }
            }
        }
        area(processing)
        {
            action(MarkAsAllumni)
            {
                ApplicationArea = Basic;
                Caption = 'Mark As Alluminae';
                Image = Status;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to mark this students as an alluminae?',true) = true then begin
                    Status:=Status::Alumni;
                    Modify;
                    end;
                end;
            }
        }
    }

    var
        stud: Record Customer;
        sems: Record UnknownRecord61692;
        acadYear: Record UnknownRecord61382;
        deptemp: Record UnknownRecord61755;
        ACAClearanceApprovalEntries: Record UnknownRecord61758;
        usersetup: Record "User Setup";
        webportals: Codeunit webportals;
        progs: Record UnknownRecord61511;
        ACACourseRegistration: Record UnknownRecord61532;
}

