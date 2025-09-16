#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78050 "ACA-Update Student Names"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Posting Group"=filter('STUDENT'),Name=filter(<>''));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if StrLen(Customer.Name)>100 then Customer.Name:=CopyStr(Customer.Name,1,100);
                RemainingRecs:=RemainingRecs-1;
                Customer.Name:=FormatNames(Customer.Name);
                Customer.Modify;
                dialsz.Update(2,Format(RemainingRecs));

                dialsz.Update(3,Format(Customer."No."));
            end;

            trigger OnPostDataItem()
            begin
                dialsz.Close;
            end;

            trigger OnPreDataItem()
            begin
                dialsz.Open('#1############################################################\'+
                '#2#################################################################'+
                '#3#################################################################');
                totrec:=Customer.Count;
                RemainingRecs:=totrec;
                dialsz.Update(1,Format(totrec));
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
        totrec: Integer;
        RemainingRecs: Integer;
        dialsz: Dialog;

    local procedure FormatNames(CommonName: Text[250]) NewName: Text[250]
    var
        NamesSmall: Text[250];
        FirsName: Text[250];
        SpaceCount: Integer;
        SpaceFound: Boolean;
        Counts: Integer;
        Strlegnth: Integer;
        OtherNames: Text[250];
    begin
        Clear(NamesSmall);
        Clear(FirsName);
        Clear(SpaceCount);
        Clear(SpaceFound);
        Clear(OtherNames);
        if StrLen(CommonName)>100 then  CommonName:=CopyStr(CommonName,1,100);
        Strlegnth:=StrLen(CommonName);
        if StrLen(CommonName)>4 then begin
          NamesSmall:=Lowercase(CommonName);
          repeat
            begin
              SpaceCount+=1;
              if ((CopyStr(NamesSmall,SpaceCount,1)='') or (CopyStr(NamesSmall,SpaceCount,1)=' ') or (CopyStr(NamesSmall,SpaceCount,1)=',')) then SpaceFound:=true;
              if not SpaceFound then begin
                FirsName:=FirsName+UpperCase(CopyStr(NamesSmall,SpaceCount,1));
                end else  begin
                  if StrLen(OtherNames)<150 then begin
                if ((CopyStr(NamesSmall,SpaceCount,1)='') or (CopyStr(NamesSmall,SpaceCount,1)=' ') or (CopyStr(NamesSmall,SpaceCount,1)=',')) then begin
                  OtherNames:=OtherNames+' ';
                SpaceCount+=1;
                  OtherNames:=OtherNames+UpperCase(CopyStr(NamesSmall,SpaceCount,1));
                  end else begin
                  OtherNames:=OtherNames+CopyStr(NamesSmall,SpaceCount,1);
                    end;

                end;
                end;
            end;
              until ((SpaceCount=Strlegnth))
          end;
          Clear(NewName);
        NewName:=FirsName+','+OtherNames;
    end;
}

