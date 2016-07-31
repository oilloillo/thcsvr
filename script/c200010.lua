 
--绯想✿伊吹萃香
function c200010.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c200010.con)
	e1:SetValue(c:GetDefence())
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c200010.con)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200010,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c200010.op1)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c200010.atop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(200010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c200010.cost)
	e3:SetTarget(c200010.sptg)
	e3:SetOperation(c200010.spop)
	c:RegisterEffect(e3)
end
function c200010.con(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c200010.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200110)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200010.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.GetAttacker()==c) or (Duel.GetAttackTarget() and (Duel.GetAttackTarget()==c)) then
		c:RegisterFlagEffect(200010,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c200010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c200010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(200010)>0 and 
	Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
	Duel.IsPlayerCanSpecialSummonMonster(tp,200999,0,0x208,0,0,1,RACE_ZOMBIE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c200010.filter(c)
	return c:IsCode(200210) and c:IsAbleToHand()
end
function c200010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,200999,0,0x208,0,0,1,RACE_ZOMBIE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,200999)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	token=Duel.CreateToken(tp,200999)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local tc=Duel.GetFirstMatchingCard(c200010.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		if Duel.SelectYesNo(tp,aux.Stringid(200010,2)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end