 
--绯想✿蕾米莉亚·斯卡雷特
function c200007.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c200007.synfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22024)
	c:RegisterEffect(e1)
	--Race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200007,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c200007.seqcon)
	e1:SetOperation(c200007.seqop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c200007.atkcon)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--des
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)--+EFFECT_FLAG_NO_TURN_RESET
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetOperation(c200007.op2)
	c:RegisterEffect(e3)
end
function c200007.synfilter(c)
	local x=c:GetOriginalCode()
	return x>=200001 and x<=200020
end
function c200007.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function c200007.seqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=0
	if s==1 then nseq=0
	elseif s==2 then nseq=1
	elseif s==4 then nseq=2
	elseif s==8 then nseq=3
	else nseq=4 end
	Duel.MoveSequence(e:GetHandler(),nseq)
end
function c200007.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttackTarget()~=nil
		and ((Duel.GetAttacker()==e:GetHandler()) or (Duel.GetAttackTarget()==e:GetHandler()))
		and Duel.GetAttacker():GetSequence()+Duel.GetAttackTarget():GetSequence()==4
end
function c200007.filter(c)
	return c:IsCode(200207) and c:IsAbleToHand()
end
function c200007.op2(e,tp,eg,ep,ev,re,r,rp)
	local opt=2
	if not Duel.IsExistingMatchingCard(c200007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then opt=0
	else opt=Duel.SelectOption(tp,aux.Stringid(200007,1),aux.Stringid(200007,2)) end
	if opt==1 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c200007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(300)
		e:GetHandler():RegisterEffect(e1)
		local token=Duel.CreateToken(tp,200107)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--		Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end