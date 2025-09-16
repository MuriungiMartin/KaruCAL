#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78020 "Send Hostel E-Mails"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("ACA-Students Hostel Rooms";"ACA-Students Hostel Rooms")
        {
            DataItemTableView = where(Cleared=const(false));
            RequestFilterFields = Student,Semester,"Hostel No","Room No";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //send hostel email
                ObjCust.Reset;
                ObjCust.SetRange("No.","ACA-Students Hostel Rooms".Student);
                if ObjCust.FindFirst then begin
                  ObjHostel.Reset;
                  ObjHostel.SetRange(Student,ObjCust."No.");
                  ObjHostel.SetRange(Semester,"ACA-Students Hostel Rooms".Semester);
                  if ObjHostel.FindFirst then begin
                          MailBody:='This is to notify you that you have been allocated accommodation at the university. '+
                'You have been allocated Block '+ObjHostel."Hostel No"+', Room no: '+ObjHostel."Room No"+', Space: '+ObjHostel."Space No"+
                'Kindly collect the keys and other items from the Hostel manager on the reporting day. Fill the attached form and present it to the hostel manager';
                RptFileName:='D:\'+'Room Agreement_'+DelChr(ObjHostel.Student,'=','/')+'.pdf';

                if Exists(RptFileName) then
                  Erase(RptFileName);
                Report.SaveAsPdf(Report::"Resident Room Agreement",RptFileName,ObjCust);
                      SendMail.SendEmailEasy_WithAttachment('Dear ',ObjCust.Name,MailBody,'','Karatina University','Hostel Manager',ObjCust."E-Mail",'HOSTEL ALLOCATION BLOCK',RptFileName,RptFileName);
                if Exists(RptFileName) then
                  Erase(RptFileName);
                    end;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                Sem:="ACA-Students Hostel Rooms".GetFilter(Semester);
                if Sem='' then
                  Error('Please Input semester filter!');
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
        SendMail: Codeunit webportals;
        RptFileName: Text;
        MailBody: Text;
        ObjHostel: Record "ACA-Students Hostel Rooms";
        ObjCust: Record Customer;
        Sem: Text;
}

