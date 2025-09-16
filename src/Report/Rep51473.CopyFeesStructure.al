#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51473 "Copy Fees Structure"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Copy Fees Structure.rdlc';

    dataset
    {
        dataitem(UnknownTable61523;UnknownTable61523)
        {
            RequestFilterFields = "Copy From Programme","Copy To Programme","Copy From Semester","Copy To Semester";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin

                FS.Reset;
                FS.SetRange(FS.Semester,"ACA-Fee By Stage".Semester);
                FS.SetRange(FS."Programme Code","ACA-Fee By Stage"."Programme Code");
                FS.SetRange(FS."Stage Code","ACA-Fee By Stage"."Stage Code");
                //FS.SETRANGE(FS.Campus,"Fee By Stage".Campus) ;
                //FS.SETRANGE(FS."Student Type","Fee By Stage"."Student Type");

                if FS.Find('-') then begin

                 FS1.Reset;
                 FS1.SetFilter(FS1."Programme Code",GetFilter("ACA-Fee By Stage"."Copy To Programme"));
                 FS1.SetRange(FS1."Stage Code",FS."Stage Code");
                 FS1.SetFilter(FS1.Semester,"ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Semester"));
                // FS.SETRANGE(FS.Campus,"Fee By Stage".Campus) ;
                // FS.SETRANGE(FS."Student Type","Fee By Stage"."Student Type");
                // FS.SETRANGE(FS."Settlemet Type","Fee By Stage"."Settlemet Type");
                 if not FS1.Find('-') then begin

                 repeat
                 FS2.Init;
                 FS2."Programme Code":="ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Programme");
                 FS2."Stage Code":=FS."Stage Code";
                 FS2.Semester:="ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Semester");
                 FS2."Student Type":=FS."Student Type";
                 FS2."Settlemet Type":=FS."Settlemet Type";
                 FS2."Seq.":="Seq.";
                 //FS2.Group:=FS.Group;
                 //FS2.Campus:=Campus;
                 FS2."Break Down":=FS."Break Down";
                 FS2.Remarks:=FS.Remarks;
                 FS2."Amount Not Distributed":=FS."Amount Not Distributed";
                 FS2.Insert ;

                 SC1.Reset;
                 SC1.SetRange(SC1."Programme Code","ACA-Fee By Stage"."Programme Code");
                 SC1.SetRange(SC1."Stage Code","ACA-Fee By Stage"."Stage Code");
                 if SC1.Find('-') then begin
                 repeat
                 SC2.Init;
                 SC2."Programme Code":="ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Programme");
                 SC2."Stage Code":=SC1."Stage Code";
                 SC2.Code:=SC1.Code;
                 SC2."Settlement Type":=SC1."Settlement Type";
                 SC2.Semester:=SC1.Semester;
                 SC2.Description:=SC1.Description;
                 SC2.Amount:= SC1.Amount;
                 SC2."Student Type":=SC1."Student Type";
                 SC2.Insert;
                 until SC1.Next=0;
                 end;
                 until FS.Next=0;
                 end;
                end;
            end;

            trigger OnPreDataItem()
            begin

                  if "ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy From Semester")='' then
                   Error('You must select the Copy from semester');
                  if "ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Semester")='' then
                   Error('You must select the Copy To semester');
                  if "ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy From Programme")='' then
                   Error('You must select the Copy from Programme');
                  if "ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Programme")='' then
                   Error('You must select the Copy To Programme');

                SetFilter("ACA-Fee By Stage"."Programme Code","ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy From Programme"));
                SetFilter("ACA-Fee By Stage".Semester,"ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy From Semester"));

                FS.Reset;
                FS.SetFilter(FS.Semester,"ACA-Fee By Stage".GetFilter("Copy To Semester"));
                FS.SetFilter(FS."Programme Code","ACA-Fee By Stage".GetFilter("ACA-Fee By Stage"."Copy To Programme"));
                //FS.SETFILTER(FS."Stage Code","Fee By Stage".GETFILTER("Fee By Stage"."Stage Code"));

                if FS.Find('-') then Error('Semester '+"ACA-Fee By Stage".GetFilter("Copy To Semester")+' Already Exist in the Fees Structure');
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
        FS: Record UnknownRecord61523;
        FS2: Record UnknownRecord61523;
        FS1: Record UnknownRecord61523;
        SC1: Record UnknownRecord61533;
        SC2: Record UnknownRecord61533;
}

