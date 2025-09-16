#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51675 "Clearance Form (Report)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Clearance Form (Report).rdlc';
    Caption = 'Student Clearance Form';
    UseRequestPage = true;

    dataset
    {
        dataitem(Clearances;UnknownTable61758)
        {
            DataItemTableView = sorting(Sequence) order(ascending);
            RequestFilterFields = "Academic Year",Semester,"Student ID";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(ClearanceCode;Clearances."Clearance Level Code")
            {
            }
            column(CodeCaption;ACAClearanceLevelCodes.Caption)
            {
            }
            column(ApprovalTitle;ACAClearanceLevelCodes."Approval Title")
            {
            }
            column(ApprovalStatement;ACAClearanceLevelCodes."Approval Statement")
            {
            }
            column(sAdmissionDate;Customer."Admission Date")
            {
            }
            column(sNo;Customer."No.")
            {
            }
            column(SName;UpperCase(Customer.Name))
            {
            }
            column(intake;Customer."Intake Code")
            {
            }
            column(ProgEnd;Customer."Programme End Date")
            {
            }
            column(status;Customer.Status)
            {
            }
            column(RefundonPV_Customer;Customer."Refund on PV")
            {
            }
            column(Bal;Customer."Balance (LCY)"+Customer."Refund on PV")
            {
            }
            column(currProg;Customer."Current Programme")
            {
            }
            column(currDate;Today)
            {
            }
            column(compName;' P.O. BOX 15653 - 00503 KARATINA TEL: +254-020-2071391')
            {
            }
            column(progName;Prog.Description)
            {
            }
            column(deptName;DimVal.Name)
            {
            }
            column(LastInDate;LastInDate)
            {
            }
            column(footer1;footer1)
            {
            }
            column(footer2;footer2)
            {
            }
            column(footer3;footer3)
            {
            }
            column(Seq;Clearances.Sequence)
            {
            }
            column(class;Customer."Class Code")
            {
            }
            column(Statuses;Statuses)
            {
            }
            column(ApprovalDate;ApprovalDateTime)
            {
            }
            column(RegistraApprovalDateTime;RegistraApprovalDateTime)
            {
            }
            column(Pics;UserSetup."User Signature")
            {
            }
            column(RegistrarStatuses;RegistrarStatuses)
            {
            }
            column(RegistrarName;RegistrarNames)
            {
            }
            column(SeqOrder;ACAClearanceLevelCodes.Sequence)
            {
            }
            column(RegistrarSignature;UserSetupRegistrar."User Signature")
            {
            }
            dataitem(ClearanceProperty;UnknownTable61752)
            {
                DataItemLink = "Clearance Level Code"=field("Clearance Level Code"),"Student ID"=field("Student ID"),Semester=field(Semester),"Academic Year"=field("Academic Year");
                column(ReportForNavId_17; 17)
                {
                }
                column(PropName;ClearanceProperty."Property Description")
                {
                }
                column(PropValue;ClearanceProperty."Property Value")
                {
                }
                column(TotPropertyValue;ClearanceProperty."Total Property Value")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ApprovalDateTime);
                ACAClearanceLevelCodes.Reset;
                ACAClearanceLevelCodes.SetRange("Clearance Level Code",Clearances."Clearance Level Code");
                if ACAClearanceLevelCodes.Find('-') then;
                Customer.Reset;
                Customer.SetRange("No.",Clearances."Student ID");
                if Customer.Find('-') then;
                Clear(LastInDate);
                courseReg.Reset;
                Clear(progName);
                courseReg.SetRange(courseReg."Student No.",Clearances."Student ID");
                courseReg.SetFilter(courseReg.Programme,'<>%1','');
                if courseReg.Find('+') then begin
                if courseReg."Registration Date"<>0D then LastInDate:=courseReg."Registration Date";
                //Prog.RESET;
                //Prog.SETRANGE(Prog.Code,courseReg.Programme);
                //IF Prog.FIND('-') THEN BEGIN
                //progName:=UPPERCASE(Prog.Description);
                //END;
                end;
                if LastInDate=0D  then begin
                 custledg.Reset;
                 custledg.SetRange(custledg."Customer No.",Customer."No.");
                 if custledg.Find('-') then begin
                 LastInDate:=custledg."Posting Date";
                 end;
                end;

                Clear(DeptName);
                //CALCFIELDS("Student Programme");
                Prog.Reset;
                Prog.SetRange(Prog.Code,courseReg.Programme);
                if Prog.Find('-') then begin
                progName:=UpperCase(Prog.Description);
                DimVal.Reset;
                DimVal.SetRange(DimVal."Dimension Code",'DEPARTMENT');
                DimVal.SetRange(DimVal.Code,Prog."Department Code");
                if DimVal.Find('-') then begin
                DeptName:=UpperCase(DimVal.Name);
                end;
                end;
                Clear(Statuses);
                Clear(RegistraApprovalDateTime);
                Clear(RegistrarStatuses);
                UserSetup.Reset;
                UserSetup.SetRange("User ID",Clearances."Clear By ID");
                  UserSetup.SetRange("Is Registrar",true);
                if Clearances.Status=Clearances.Status::Cleared then begin
                  if UserSetup.Find('-') then UserSetup.CalcFields("User Signature");
                  Statuses:='APPROVED';
                  ApprovalDateTime:=CreateDatetime(Clearances."Last Date Modified",Clearances."Last Time Modified");

                end else if Clearances.Status=Clearances.Status::Rejected then  Statuses:='REJECTED'
                else  Statuses:='PENDING';
                if ((Clearances.Status=Clearances.Status::Cleared) and (Clearances.Cleared=false)) then begin
                    CurrReport.Skip;
                  end;
                  Clear(RegistraApprovalDateTime);
                  UserSetupRegistrar.Reset;
                  Clear(RegistrarNames);
                  ACAClearanceApprovalEntriesRegistrar.Reset;
                  ACAClearanceApprovalEntriesRegistrar.SetRange("Student ID",Clearances."Student ID");
                  ACAClearanceApprovalEntriesRegistrar.SetRange("Priority Level",ACAClearanceApprovalEntriesRegistrar."priority level"::"Final level");
                  ACAClearanceApprovalEntriesRegistrar.SetRange(Cleared,true);
                  ACAClearanceApprovalEntriesRegistrar.SetRange(Status,ACAClearanceApprovalEntriesRegistrar.Status::Cleared);
                  if ACAClearanceApprovalEntriesRegistrar.Find('-') then begin
                      RegistraApprovalDateTime:=CreateDatetime(ACAClearanceApprovalEntriesRegistrar."Last Date Modified",ACAClearanceApprovalEntriesRegistrar."Last Time Modified");;

                  if UserSetupRegistrar.Get(ACAClearanceApprovalEntriesRegistrar."Clear By ID") then UserSetupRegistrar.CalcFields("User Signature");
                  if UserSetupRegistrar.UserName<>'' then RegistrarNames:=UserSetupRegistrar.UserName else RegistrarNames:=UserSetupRegistrar."User ID";
                    end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Faculty: Text[100];
        Prog: Record UnknownRecord61511;
        ProgStages: Record UnknownRecord61516;
        courseReg: Record UnknownRecord61532;
        progName: Text[250];
        clearance_Levels: Record UnknownRecord61754;
        DeptName: Code[100];
        LastInDate: Date;
        DimVal: Record "Dimension Value";
        footer1: label 'All Students, upon completing a course, must ensure that they have been cleared from all sections above. It is the student''s';
        footer2: label 'responsibility to obtain clearance from all subject tutors and relevant officers. This Form when completed MUST be returned to the ';
        footer3: label 'Academic REGISTRAR''S Office.';
        custledg: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        ACAClearanceLevelCodes: Record UnknownRecord61754;
        Statuses: Code[20];
        ApprovalDateTime: DateTime;
        RegistraApprovalDateTime: DateTime;
        RegistrarStatuses: Code[20];
        UserSetup: Record "User Setup";
        ACAClearanceApprovalEntriesRegistrar: Record UnknownRecord61758;
        UserSetupRegistrar: Record "User Setup";
        RegistrarNames: Text[150];
}

