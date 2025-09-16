#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51770 "Multiple Student Records"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Multiple Student Records.rdlc';

    dataset
    {
        dataitem(UnknownTable61748;UnknownTable61748)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(Student_No;"ACA-Multiple Student Records"."Student No.")
            {
            }
            column(Student_Name;"ACA-Multiple Student Records"."Student Name")
            {
            }
            column(Times_Repeated;"ACA-Multiple Student Records"."Times Repeated")
            {
            }
            column(seq;seq)
            {
            }
            column(bak;"ACA-Multiple Student Records"."Balance Amount")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  seq:=seq+1;
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

    trigger OnPreReport()
    begin
         PopulateRepetitions();
         Clear(seq);
    end;

    var
        seq: Integer;


    procedure PopulateRepetitions()
    var
        cust: Record Customer;
        cust2: Record Customer;
        multiplecust: Record UnknownRecord61748;
        multiplecust2: Record UnknownRecord61748;
    begin
        multiplecust.Reset;
        if multiplecust.Find('-') then multiplecust.DeleteAll;

        cust.Reset;
        cust.SetRange(cust."Customer Posting Group",'STUDENT');
        if cust.Find('-') then begin
          repeat
           cust2.Reset;
           cust2.SetRange(cust2.Name,cust.Name);
           if cust2.Find('-') then begin
           if cust2.Count>1 then begin
           repeat
              multiplecust.Reset;
              multiplecust.SetRange(multiplecust."Student No.",cust2."No.");
              if not multiplecust.Find('-') then begin
              cust2.CalcFields(cust2.Balance);
                // Insert into Multiple
                multiplecust2.Init;
                multiplecust2."Student No.":=cust2."No.";
                multiplecust2."Student Name":=cust2.Name;
                multiplecust2."Times Repeated":=cust2.Count;
                multiplecust2."Balance Amount":=cust2.Balance;
                multiplecust2.Insert(true);
              end;
              // Insert in multiple if more than one records exists
            until cust2.Next = 0;
             end;
           end;
          until cust.Next = 0;
        end;
    end;
}

