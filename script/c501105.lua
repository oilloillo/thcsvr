--黄金之魔女-安琪
function c501105.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(501105,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,501105)
	e5:SetCost(c501105.cost)
	e5:SetTarget(c501105.target)
	e5:SetOperation(c501105.activate)
	c:RegisterEffect(e5)
end
function c501105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c501105.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x811) and c:IsRankBelow(7) and not c:IsCode(501105) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c501105.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c501105.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c501105.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c501105.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c501105.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup()  and c:IsRelateToEffect(e) then
		--c:CancelToGrave()
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	    tc:CompleteProcedure()
	end
end

