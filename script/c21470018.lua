 
--满月夜的百鬼夜行
function c21470018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470018.reset)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(21470005)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21470018,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SSET)
	e3:SetCountLimit(1,21470018)
--	e3:SetCost(c21470018.cost)
	e3:SetTarget(c21470018.tg)
	e3:SetOperation(c21470018.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21470018,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_MSET)
	e4:SetCountLimit(1,21470018)
--	e4:SetCost(c21470018.cost)
	e4:SetTarget(c21470018.tg2)
	e4:SetOperation(c21470018.op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHANGE_POS)
	e5:SetTarget(c21470018.tg3)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c21470018.reset(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	e:GetHandler():ResetFlagEffect(21470018)
end--[[
function c21470018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21470018)<=0 end
	Duel.RegisterFlagEffect(tp,21470018,RESET_PHASE+PHASE_END,0,1)
end]]
function c21470018.filter(c,tp)
	return c:IsSetCard(0x742) and c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD) and c:GetControler()==tp
end
function c21470018.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c21470018.filter,nil,tp):GetFirst()
	if tg==nil then return end
	if chk==0 then return Duel.IsExistingMatchingCard(IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
end
function c21470018.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c21470018.filter,nil,tp):GetFirst()
	if tg==nil then return end
	if chk==0 then return Duel.IsExistingMatchingCard(IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
end
function c21470018.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:Filter(c21470018.filter,nil,tp):GetFirst()
	if tg==nil then return end
	if (tg:IsCode(21470012) or tg:IsCode(21470013)) and tg:GetFlagEffect(21470020)~=0 then
		if chk==0 then return Duel.IsExistingMatchingCard(IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	else
		if chk==0 then return Duel.IsExistingMatchingCard(IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	end
end
function c21470018.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFlagEffect(tp,21470017)<=0 and e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():IsFaceup() then 
		local tg=eg:Filter(c21470018.filter,nil,tp):GetFirst()
		if tg==nil then return end
		local g=Group.CreateGroup()
		if (tg:IsCode(21470012) or tg:IsCode(21470013)) and tg:GetPreviousLocation()==LOCATION_MZONE then
			if tg:GetFlagEffect(21470020)~=0 then
				if Duel.IsExistingMatchingCard(IsDestructable,tp,0,LOCATION_MZONE,1,nil) 
				and Duel.IsExistingMatchingCard(IsDestructable,tp,0,LOCATION_SZONE,1,nil) then
					local opt=Duel.SelectOption(tp,aux.Stringid(21470018,0),aux.Stringid(21470018,1))
					if opt==0 then 
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						g=Duel.SelectMatchingCard(tp,IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
					else 
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						g=Duel.SelectMatchingCard(tp,IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
					end
				else 
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					g=Duel.SelectMatchingCard(tp,IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
				end
			else 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				g=Duel.SelectMatchingCard(tp,IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
			end
		else 
			if tg:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				g=Duel.SelectMatchingCard(tp,IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				g=Duel.SelectMatchingCard(tp,IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
			end
		end
		local tc=g:GetFirst()
		Duel.ConfirmCards(tp,tg)
		Duel.ConfirmCards(1-tp,tg)
		Duel.Destroy(tc,REASON_EFFECT)
		if e:GetHandler():GetTurnCounter()==0 and e:GetHandler():GetFlagEffect(21470018)==0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			e2:SetOperation(c21470018.destroy)
			e:GetHandler():RegisterEffect(e2)
			e:GetHandler():RegisterFlagEffect(21470018,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		Duel.RegisterFlagEffect(tp,21470017,RESET_PHASE+PHASE_END,0,1)
	end
end
function c21470018.destroy(e,tp,eg,ep,ev,re,r,rp)
	if tp==Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end