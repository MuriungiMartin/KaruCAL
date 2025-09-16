#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51235 "Daily Menu Stock"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Daily Menu Stock.rdlc';

    dataset
    {
        dataitem(UnknownTable61156;UnknownTable61156)
        {
            DataItemTableView = sorting("Line No");
            column(ReportForNavId_2065; 2065)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Daily_Menu_Buffer__Item_No_;"Item No")
            {
            }
            column(Daily_Menu_Buffer_Description;Description)
            {
            }
            column(Daily_Menu_Buffer_Units;Units)
            {
            }
            column(Daily_Menu_Buffer_Quantity;Quantity)
            {
            }
            column(Daily_Menu_Buffer__Total_Qty_;"Total Qty")
            {
            }
            column(Daily_Menu_Buffer__Unit_Cost_;"Unit Cost")
            {
            }
            column(Daily_Menu_Buffer__Total_Cost_;"Total Cost")
            {
            }
            column(Daily_Menu_Buffer__Total_Cost__Control1000000038;"Total Cost")
            {
            }
            column(Daily_Menu_Stock_RegisterCaption;Daily_Menu_Stock_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Daily_Menu_Buffer__Item_No_Caption;FieldCaption("Item No"))
            {
            }
            column(Daily_Menu_Buffer_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Daily_Menu_Buffer_UnitsCaption;FieldCaption(Units))
            {
            }
            column(Daily_Menu_Buffer_QuantityCaption;FieldCaption(Quantity))
            {
            }
            column(Daily_Menu_Buffer__Total_Qty_Caption;FieldCaption("Total Qty"))
            {
            }
            column(Daily_Menu_Buffer__Unit_Cost_Caption;FieldCaption("Unit Cost"))
            {
            }
            column(Daily_Menu_Buffer__Total_Cost_Caption;FieldCaption("Total Cost"))
            {
            }
            column(Daily_Menu_Buffer__Total_Cost__Control1000000038Caption;FieldCaption("Total Cost"))
            {
            }
            column(Daily_Menu_Buffer_Line_No;"Line No")
            {
            }

            trigger OnPreDataItem()
            begin
                 Buffer2.DeleteAll;
                 "CAT-Daily Menu Buffer".DeleteAll;
                 "Buffer Copy".DeleteAll;

                 MenuRec.SetRange(MenuRec."Menu Date",MenuDate);
                 if MenuRec.Find('-') then
                 begin
                   repeat
                    "Menu Food".SetRange("Menu Food".Code,MenuRec.Menu);
                    if "Menu Food".Find('-') then
                    begin
                      repeat
                        "Menu Inv".SetRange("Menu Inv".Menu,"Menu Food".Code);
                        if "Menu Inv".Find('-') then
                        begin
                          repeat
                             LineNo:=LineNo+1;
                             Buffer2.Init;
                             Buffer2."Line No":=LineNo;
                             Buffer2."Item No":="Menu Inv"."Item No";
                             Buffer2.Description:="Menu Inv".Description;
                             Buffer2.Units:="Menu Inv".Units;
                             Buffer2.Quantity:="Menu Inv".Quantity;
                             Buffer2."Unit Cost":="Menu Inv"."Unit Cost";

                             Buffer2.Insert(true);

                          until "Menu Inv".Next=0;
                          "Menu Inv".Reset;
                        end;
                       until "Menu Food".Next=0;
                       "Menu Food".Reset;
                      end;
                     until MenuRec.Next=0;
                   end;
                   Qty:=0;
                   if Buffer2.Find('-') then
                   begin
                    repeat
                      "Buffer Copy".SetRange("Buffer Copy"."Item No",Buffer2."Item No");
                      if "Buffer Copy".Find('-') then
                      begin
                        repeat
                         Qty:=Qty+1;
                        until "Buffer Copy".Next=0;
                         LineNo:=LineNo+10;
                           "CAT-Daily Menu Buffer".Init;
                           "CAT-Daily Menu Buffer"."Line No":=LineNo;
                           "CAT-Daily Menu Buffer"."Item No":="Buffer Copy"."Item No";
                           "CAT-Daily Menu Buffer".Description:= "Buffer Copy".Description;
                           "CAT-Daily Menu Buffer".Units:="Buffer Copy".Units;
                           "CAT-Daily Menu Buffer".Quantity:="Buffer Copy".Quantity;
                           "CAT-Daily Menu Buffer"."Total Qty":="Buffer Copy".Quantity*Qty;
                           "CAT-Daily Menu Buffer"."Unit Cost":="Buffer Copy"."Unit Cost";
                           "CAT-Daily Menu Buffer"."Total Cost":="Buffer Copy"."Unit Cost" * "CAT-Daily Menu Buffer"."Total Qty";
                           "CAT-Daily Menu Buffer".Insert(true) ;
                           Qty:=0;
                      end;
                    until Buffer2.Next=0;
                   end;

                   "CAT-Daily Menu Buffer".SetCurrentkey("CAT-Daily Menu Buffer"."Item No");
                   if "CAT-Daily Menu Buffer".Find('-') then
                   begin
                     repeat
                      if "CAT-Daily Menu Buffer"."Item No"=LastItm then
                      begin
                         "CAT-Daily Menu Buffer".Delete
                      end;
                      LastItm:="CAT-Daily Menu Buffer"."Item No";
                     until "CAT-Daily Menu Buffer".Next=0;
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
        MenuDate: Date;
        MenuRec: Record UnknownRecord61169;
        "Menu Inv": Record UnknownRecord61168;
        "Menu Food": Record UnknownRecord61167;
        LineNo: Integer;
        Buffer2: Record UnknownRecord61166;
        "Buffer Copy": Record UnknownRecord61166;
        Qty: Decimal;
        LastItm: Code[10];
        Daily_Menu_Stock_RegisterCaptionLbl: label 'Daily Menu Stock Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

