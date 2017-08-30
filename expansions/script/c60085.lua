 
--白焰的呼唤
function c60085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60085.target)
	e1:SetOperation(c60085.activate)
	c:RegisterEffect(e1)
end
function c60085.filter(c,e,tp)
	return c:IsSetCard(0x191) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60085.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c60085.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60085.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetTurnPlayer()~=tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DRAW)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c60085.condition)
	e2:SetOperation(c60085.operation)
	Duel.RegisterEffect(e2,tp)
end
function c60085.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c60085.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1500,REASON_EFFECT)
end
