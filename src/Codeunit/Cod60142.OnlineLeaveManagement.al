#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60142 "Online Leave Management"
{

    trigger OnRun()
    begin
    end;

    var
        Leave: Record UnknownRecord61282;
        emp: Record UnknownRecord61188;
        ret_date: Date;
        i: Integer;
        enddate: Date;
        returnday: Record Date;
        employeefetch: Record UnknownRecord61188;


    procedure LeaveMgmt(TransactionType: Option New,Modify,Delete;No_: Code[20];"Leave Code": Code[20];"Days Applied": Integer;"Start Date": Date;Approver: Code[20];"Approved Start Date": Date;"Approved Days": Integer;Taken: Boolean;Status: Option Pending,"HOD Approval","Records Officer","Registry in Charge",Registrar,Rejected,Approved;"Owner Comments": Text[250];"HOD Comments": Text[250];Applicant: Code[20];"Registry in Charge": Code[20];"Registrar Administration": Code[20];"Records Officer": Code[20];"Head of Department": Code[20]) "Header No": Code[20]
    begin
        employeefetch.Reset;
        employeefetch.SetRange(employeefetch."No.","Head of Department");
        if employeefetch.Find('-') then
        begin
        end;

        Leave.Init;
         Clear(enddate);

        ret_date:="Start Date";
        //ret_date:=CALCDATE('-1D',ret_date);
        Clear(i);

        while (i<"Days Applied") do begin
         ret_date:=CalcDate('1D',ret_date);
        returnday.Reset;
        returnday.SetRange(returnday."Period Type",returnday."period type"::Date);
        returnday.SetRange(returnday."Period Start",ret_date);
        if returnday.Find('-') then begin
          if ((returnday."Period Name"<>'Saturday') and (returnday."Period Name"<>'Sunday')) then begin
            i:=i+1;
          end;
        end;

        end;

        case TransactionType of
          Transactiontype::New: begin
              Leave."Employee No":=Applicant;
              Leave."Application Date":=Today;
              Leave."Leave Code":='ANNUAL';
              Leave."Head of Department":="Head of Department";
             Leave."Head of Department Name":= employeefetch."First Name" +' '+employeefetch."Middle Name"+' '+employeefetch."Last Name";


              Leave.Insert(true);
              "Header No":=Leave."Application Code";
          end;

          Transactiontype::Modify: begin

              Leave.Reset;
              Leave.SetRange(Leave."Application Code",No_);

              if Leave.Find('-')then begin
                 Leave."Leave Code":="Leave Code";
                 Leave."Days Applied":="Days Applied";
                 Leave."Start Date":="Start Date";
                 Leave."Return Date":=ret_date;//"Start Date"+"Days Applied";
                 Leave."HOD ID":=Approver;
                 Leave."Registry in Charge":="Registry in Charge";
                 Leave.Registrar:="Registrar Administration";
                 Leave."Records Officer":="Records Officer";
                 Leave.Comments:="Owner Comments";
                 Leave.Status:=Leave.Status::"HOD Approval";
                 Leave."Head of Department":="Head of Department";
                 Leave.Modify(true);
              end;
          end;

          Transactiontype::Delete: begin
              Leave.Reset;
              Leave.SetRange(Leave."Application Code",No_);

              if Leave.Find('-')then Leave.Delete(true)
              else Error('No record found');

          end;
        end;
    end;


    procedure Status(Doc_No: Code[20];"Approver Comments": Text[250];"Registry in Charge Comm": Text[250];"Registrar Administration Comm": Text[250];"Records Officer Comm": Text[250];Status: Option Pending,"HOD Approval","Records Officer","Registry in Charge",Registrar,Rejected,Approved)
    begin
        Leave.Reset;
        Leave.SetRange(Leave."Application Code",Doc_No);
        if(Leave.Find('-'))then begin
          //Pending,HOD Approval,HR Approval,MD Approval,Rejected,Canceled,Approved
          Leave."HOD Start Date":=Leave."Start Date";
          Leave."HOD Approved Days":=Leave."Approved Days";
          Leave."HOD Return Date":=Leave."Return Date";
          Leave."Approver Comment":="Approver Comments";

          Leave."HOD Comm":="Approver Comments";
          Leave."Registry in Charge Comm":="Registry in Charge Comm";
          Leave."Registrar Comm":="Registrar Administration Comm";
          Leave."Records Officer Comm":="Records Officer Comm";

          Leave.Status:=Status;

          if(Leave.Status=Leave.Status::Registrar)then begin
            emp.Reset;
            emp.SetRange(emp."No.",Leave."Employee No");
            if(emp.Find('-'))then begin
              emp."Leave Balance":=emp."Leave Balance"-Leave."Approved Days";
              emp.Modify(true);
            end;
          end;

          Leave.Modify;
        end;
    end;


    procedure ReturnDate("Start Date": Date;Days: Integer) "Return Date": Date
    begin
         Clear(enddate);

        ret_date:="Start Date";
        //ret_date:=CALCDATE('-1D',ret_date);
        Clear(i);

        while (i<Days) do begin
         ret_date:=CalcDate('1D',ret_date);
        returnday.Reset;
        returnday.SetRange(returnday."Period Type",returnday."period type"::Date);
        returnday.SetRange(returnday."Period Start",ret_date);
        if returnday.Find('-') then begin
          if ((returnday."Period Name"<>'Saturday') and (returnday."Period Name"<>'Sunday')) then begin
            i:=i+1;
          end;
        end;

        end;


        //"Return Date":="Start Date"+Days;
        "Return Date":=ret_date;
    end;


    procedure postHODComments(AppNo: Code[20];approveorReject: Code[10];comments: Text[250])
    begin
              Leave.Reset;
              Leave.SetRange(Leave."Application Code",AppNo);

              if Leave.Find('-')then begin
                 Leave."Head of Department Comments":=comments;
                 if approveorReject='APPROVED' then
                 Leave."Head of Department Approved":=true;
                 Leave.Modify(true);
              end;
    end;
}

