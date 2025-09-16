#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77307 "HRM-StaffClearance (Open)"
{
    Caption = 'Staff Clearance (Open)';
    CardPageID = "HRM-Clearance View Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61188;
    SourceTableView = where("Clearance Status"=filter(=open));

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
                field(names;Rec."First Name"+' '+Rec."Middle Name"+' '+Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Names';
                }
                field(Phones;"Work Phone Number"+'/'+"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Phones';
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Contract End Date";"Contract End Date")
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
                        ClearLevela: Record UnknownRecord77302;
                        ClearTemplates: Record UnknownRecord77303;
                        ClearDepTemplates: Record UnknownRecord77304;
                        ClearStandardApp: Record UnknownRecord77305;
                        empsssz: Record UnknownRecord61188;
                        ClearEntries: Record UnknownRecord77306;
                    begin
                        Clear(emp);
                        emp.Reset;
                        emp.SetRange("No.",Rec."No.");
                        if emp.Find('-') then begin end else Error('Invalid PF "Number Of Dependants"');;
                        emp.TestField("Department Code");
                           "Department Code":=emp."Department Code";

                         sems.Reset;
                         sems.SetRange(sems."Current Semester",true);
                         if sems.Find('-') then
                         if not (sems.Code='') then
                         "Clearance Semester":=sems.Code;
                         //"Programme End Date":=ACACourseRegistration."Registration Date";
                         acadYear.Reset;
                         acadYear.SetRange(acadYear.Current,true);
                         if acadYear.Find('-') then
                         if not (acadYear.Code='') then
                         "Clearance Academic Year":=acadYear.Code;
                         "Clearance Reason":="clearance reason"::Resignation;
                         Modify;

                          if not (Confirm('Initiate Staff clearance for '+"No."+': '+Rec."First Name"+' '+Rec."Middle Name"+' '+Rec."Last Name",false)=true) then Error('Cancelled!');
                         deptemp.Reset;
                         deptemp.SetFilter(deptemp."Clearance Level Code",'%1|%2','HOD','DEPARTMENT');
                         deptemp.SetRange(deptemp.Department,"Department Code");
                         if not (deptemp.Find('-')) then Error('Departmental approver for '''+"Department Code"+''' missing');
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
                                      ClearEntries.Department:="Department Code";
                                      ClearEntries."PF. No.":="No.";
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

                                  webportals.SendEmailEasy('Hi ',usersetup.UserName,'A Staff clearance request has been sent to your email for Staff No.:'+Rec."No.",
                                  'Kindly expedite.','This is a system generated mail that does not require a response unless you want to talk to a Robot!',
                                  'In case of challenges, kindly contact the ICT Directorate via ict@karu.ac.ke',usersetup."E-Mail",'STAFF CLEARANCE APPROVAL');
                                  end;
                                      end else begin  ClearEntries.Status:=ClearEntries.Status::Created;
                                    ClearEntries.Insert;
                                        end;

                                end; //1
                                until ClearStandardApp.Next =0; //  Rep1
                              end;// ELSE ERROR('Setup for Clearance Templates not found;');  // 2
                              end else begin    //3
                                // Check templates for the related Clearance Approvals
                                ClearTemplates.Reset;
                                ClearTemplates.SetRange(ClearTemplates."Clearance Level Code",ClearLevela."Clearance Level Code");
                                ClearTemplates.SetRange(ClearTemplates.Department,"Department Code");
                                ClearTemplates.SetFilter(ClearTemplates.Active,'=%1',true);
                                if ClearTemplates.Find('-') then begin  //6
                                  ClearDepTemplates.Reset;
                                 ClearDepTemplates.SetRange(ClearDepTemplates."Clearance Level Code",ClearLevela."Clearance Level Code");
                                 ClearDepTemplates.SetRange(ClearDepTemplates.Department,"Department Code");
                                 ClearDepTemplates.SetFilter(ClearDepTemplates.Active,'=%1',true);
                                  if ClearDepTemplates.Find('-') then begin//7
                                  repeat
                                  begin
                                    ClearEntries.Init;
                                      ClearEntries."Clearance Level Code":= ClearDepTemplates."Clearance Level Code";
                                      ClearEntries.Department:="Department Code";
                                      ClearEntries."PF. No.":="No.";
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
                                  webportals.SendEmailEasy('Hi ',usersetup.UserName,'A Staff clearance requeste has been sent to your email for Staff:'+Rec."No.",
                                  'Kindly expedite.','This is a system generated mail. Kindly do not respond. Unless you want to talk to a Robot!',
                                  'In case of Challenges, Kindly Talk to the ICT department',usersetup."E-Mail",'Staff CLEARANCE APPROVAL');
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
                        ACAClearanceApprovalEntries.SetRange("PF. No.","No.");
                        if ACAClearanceApprovalEntries.Find('-') then
                        Report.Run(77333,true,false,ACAClearanceApprovalEntries);
                    end;
                }
            }
        }
    }

    var
        emp: Record UnknownRecord61188;
        sems: Record UnknownRecord61692;
        acadYear: Record UnknownRecord61382;
        deptemp: Record UnknownRecord77303;
        ACAClearanceApprovalEntries: Record UnknownRecord77306;
        usersetup: Record "User Setup";
        webportals: Codeunit webportals;
}

