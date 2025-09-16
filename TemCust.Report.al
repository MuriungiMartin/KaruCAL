#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51061 "Tem Cust"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61015;UnknownTable61015)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                      Nm:="ACA-Tem Stud".Nm1;
                      if "ACA-Tem Stud".Nm2<>'' then
                      Nm:=Nm+' '+"ACA-Tem Stud".Nm2;
                      if "ACA-Tem Stud".Nm3<>'' then
                      Nm:=Nm+' '+"ACA-Tem Stud".Nm3;

                      if Cust.Get("ACA-Tem Stud".No) then begin
                      if Nm<>'' then begin
                      Cust.Name:=Nm;
                      Cust.Modify;
                      end;
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
        Cust: Record Customer;
        Nm: Text[100];
}

