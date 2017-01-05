--梦幻馆的可爱恶魔✿幻月
function c14064.initial_effect(c)
	--xyz summon
	Nef.AddXyzProcedureWithDesc(c,nil,5,3,aux.Stringid(14064,1))
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(c14064.xyzfilter),5,2,aux.Stringid(14064,2))
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(c14064.xyzfilter1),5,1,aux.Stringid(14064,3))
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14064,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c14064.spcon)
	e2:SetCost(c14064.tgcost)
	e2:SetTarget(c14064.sptg)
	e2:SetOperation(c14064.spop)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c14064.atkval)
	c:RegisterEffect(e3)
end
function c14064.xyzfilter(c)
	return c:IsFaceup() and Duel.GetFlagEffect(c:GetControler(),14038)>0
end
function c14064.xyzfilter1(c)
	return c:IsFaceup() and Duel.GetFlagEffect(c:GetControler(),14038)>1
end
function c14064.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return ep==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsContains(e:GetHandler())
end
function c14064.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14064.spfilter(c,e,tp)
	return c:IsCode(14064) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14064.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14064.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstMatchingCard(c14064.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc then
		local cg=Group.FromCards(c)
		tc:SetMaterial(cg)
		Duel.Overlay(tc,cg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c14064.atkfilter1(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x208) 
end
function c14064.atkfilter2(c)
	return c:IsSetCard(0x138) 
end
function c14064.atkval(e,c)
	local g1=Duel.GetMatchingGroup(c14064.atkfilter1,c:GetControler(),LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(c14064.atkfilter2,c:GetControler(),LOCATION_GRAVE,0,nil)
	return g2:GetSum(Card.GetLevel)*200+g1:GetSum(Card.GetRank)*200
end
