 
--教团的紧急召唤令
function c60084.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60084.tg)
	e1:SetOperation(c60084.op)
	c:RegisterEffect(e1)
end
function c60084.filter(c,e,tp)
	return c:IsSetCard(0x191) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsPublic()
end
function c60084.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c60084.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60084.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(c60084.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local conf=Duel.GetFieldGroup(tp,0x2,0)
		if conf:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,conf)
	while g:GetCount()>0 and ft>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonStep(sg:GetFirst(), 0, tp, tp, false, false, POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetValue(1)
		sg:GetFirst():RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetValue(1)
		sg:GetFirst():RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetReset(RESET_EVENT+0xff0000)
		e3:SetValue(1)
		sg:GetFirst():RegisterEffect(e3,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		--sg:GetFirst():RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetRange(LOCATION_MZONE)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e6:SetOperation(c60084.retop)
		sg:GetFirst():RegisterEffect(e6)
		ft=ft-1
		g:RemoveCard(sg:GetFirst())
	end
		Duel.SpecialSummonComplete()
		Duel.ShuffleHand(tp)
end
function c60084.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
