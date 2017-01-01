--梦幻馆的女仆幻想✿梦月
function c14063.initial_effect(c)
	--xyz summon
	Nef.AddXyzProcedureWithDesc(c,nil,4,2,aux.Stringid(14063,1))
	Nef.AddXyzProcedureWithDesc(c,aux.FilterBoolFunction(c14063.xyzfilter),4,1,aux.Stringid(14063,2))
	c:EnableReviveLimit()
	--darkness
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c14063.condition)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14063,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c14063.tgcost)
	e2:SetTarget(c14063.sptg)
	e2:SetOperation(c14063.spop)
	c:RegisterEffect(e2)
end
function c14063.xyzfilter(c)
	return c:IsFaceup() and Duel.GetFlagEffect(c:GetControler(),14038)>0
end
function c14063.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c14063.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c14063.spfilter(c,e,tp)
	return c:IsCode(14064) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c14063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14063.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14063.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstMatchingCard(c14063.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc then
		local cg=Group.FromCards(c)
		tc:SetMaterial(cg)
		Duel.Overlay(tc,cg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
